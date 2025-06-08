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
        // TODO: заменить на API
        self.expenses = MockData.expenses
            .filter { $0.tripId == trip.id }
    }

    // MARK: - Actions
    func addExpenseTapped() {
        onAddExpense?()
    }
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
    }

}
