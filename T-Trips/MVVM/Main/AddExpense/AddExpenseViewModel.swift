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
    @Published var payeeIds: [Int64] = []

    // MARK: - Outputs
    @Published private(set) var isAddEnabled = false

    // MARK: - Handlers
    var onAdd: ((Expense) -> Void)?

    private var cancellables = Set<AnyCancellable>()
    private let tripId: Int64

    init(tripId: Int64) {
        self.tripId = tripId
        Publishers.CombineLatest4($title, $amount, $category, $payerId)
            .combineLatest($payeeIds)
            .map { combined, payeeIds in
                let (title, amount, category, payerId) = combined
                guard let payerId = payerId else { return false }
                return !title.isEmpty &&
                    Double(amount) != nil &&
                    !category.isEmpty &&
                    !payeeIds.isEmpty &&
                    !payeeIds.contains(payerId)
            }
            .receive(on: RunLoop.main)
            .assign(to: \ .isAddEnabled, on: self)
            .store(in: &cancellables)
    }

    func addExpense() {
        guard
            let value = Double(amount),
            let payerId = payerId,
            !payeeIds.isEmpty,
            !payeeIds.contains(payerId)
        else { return }

        let dto = ExpenseDtoForCreate(
            category: Expense.Category(rawValue: category.uppercased()) ?? .other,
            amount: value,
            title: title,
            paidForUserIds: payeeIds
        )

        MockAPIService.shared.createExpense(tripId: tripId, dto: dto, ownerId: payerId) { [weak self] expense in
            DispatchQueue.main.async {
                self?.onAdd?(expense)
            }
        }
    }
}
