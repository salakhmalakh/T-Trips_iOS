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
    @Published var title: String = ""
    @Published var amount: String = ""
    @Published var category: String = ""
    @Published var date = Date()
    @Published var payerId: Int64?
    @Published var payeeId: Int64?

    // MARK: - Outputs
    @Published private(set) var isAddEnabled = false

    // MARK: - Handlers
    var onAdd: ((Expense) -> Void)?

    private var cancellables = Set<AnyCancellable>()
    private let tripId: Int64

    init(tripId: Int64) {
        self.tripId = tripId
        Publishers.CombineLatest4($title, $amount, $category, $payerId)
            .combineLatest($payeeId)
            .map { combined, payeeId in
                let (title, amount, category, payerId) = combined
                return !title.isEmpty &&
                    Double(amount) != nil &&
                    !category.isEmpty &&
                    payerId != nil &&
                    payeeId != nil
            }
            .receive(on: RunLoop.main)
            .assign(to: \ .isAddEnabled, on: self)
            .store(in: &cancellables)
    }

    func addExpense() {
        guard
            let value = Double(amount),
            let payerId = payerId,
            let payeeId = payeeId
        else { return }
        let expense = Expense(
            id: nil,
            tripId: tripId,
            title: title,
            category: Expense.Category(rawValue: category.uppercased()) ?? .other,
            amount: value,
            ownerId: payerId,
            createdAt: date,
            paidForUserIds: [payeeId]
        )
        onAdd?(expense)
    }
}
