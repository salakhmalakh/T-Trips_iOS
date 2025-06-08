//
//  ExpenseDetailViewModel.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 27.05.2025.
//

import Foundation
import Combine

final class ExpenseDetailViewModel {
    // MARK: - Outputs
    @Published private(set) var category: String
    @Published private(set) var amountText: String
    @Published private(set) var dateText: String
    @Published private(set) var payer: String
    @Published private(set) var payee: String
    @Published private(set) var description: String?

    // MARK: - Handlers
    var onEdit: (() -> Void)?
    var onDelete: (() -> Void)?

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init(
        expense: Expense,
        payerName: String,
        payeeName: String? = nil
    ) {
        self.category = expense.category.localized
        self.amountText = String(format: "%.2f ₽", expense.amount)
        self.dateText = formatter.string(from: expense.createdAt)
        self.payer = payerName
        self.payee = payeeName ?? ""
        self.description = expense.description
    }

    func editTapped() {
        onEdit?()
    }

    func deleteTapped() {
        onDelete?()
    }
}
