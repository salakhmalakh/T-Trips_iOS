//
//  AddExpenseViewModel.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 26.05.2025.
//

import Foundation
import Combine

final class AddExpenseViewModel {
    // MARK: - Inputs
    @Published var amount: String = ""
    @Published var category: String = ""
    @Published var date = Date()
    @Published var payer: String = ""
    @Published var payee: String = ""

    // MARK: - Outputs
    @Published private(set) var isAddEnabled = false

    // MARK: - Handlers
    var onAdd: ((Expense) -> Void)?

    private var cancellables = Set<AnyCancellable>()
    private let tripId: UUID

    init(tripId: UUID) {
        self.tripId = tripId
        Publishers.CombineLatest4($amount, $category, $payer, $payee)
            .map { amount, category, payer, payee in
                Double(amount) != nil
                && !category.isEmpty
                && !payer.isEmpty
                && !payee.isEmpty
            }
            .receive(on: RunLoop.main)
            .assign(to: \ .isAddEnabled, on: self)
            .store(in: &cancellables)
    }

    func addExpense() {
        guard let value = Double(amount) else { return }
        let expense = Expense(
            id: UUID(),
            tripId: tripId,
            category: Expense.Category(rawValue: category.uppercased()) ?? .other,
            amount: value,
            userId: UUID(),
            description: nil,
            createdAt: date
        )
        onAdd?(expense)
    }
}
