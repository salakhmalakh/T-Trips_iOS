//
//  TripViewModel.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 26.05.2025.
//

import Foundation
import Combine

final class TripViewModel {
    // MARK: - Outputs
    @Published private(set) var expenses: [Expense] = []
    let trip: Trip

    // MARK: - Handlers
    var onAddExpense: (() -> Void)?

    // MARK: - Init
    init(trip: Trip) {
        self.trip = trip
        loadExpenses()
    }

    // MARK: - Data Loading
    private func loadExpenses() {
        // TODO: replace with real API
        let now = Date()
        expenses = (1...5).map { _ in
            Expense(
                id: UUID(),
                tripId: trip.id,
                category: .food,
                amount: Double.random(in: 1000...10000),
                userId: UUID(),
                description: nil,
                createdAt: now
            )
        }
    }

    // MARK: - Actions
    func addExpenseTapped() {
        onAddExpense?()
    }
}
