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
        MockAPIService.shared.getExpenses(tripId: trip.id) { [weak self] expenses in
            DispatchQueue.main.async {
                self?.expenses = expenses
            }
        }
    }

    // MARK: - Actions
    func addExpenseTapped() {
        onAddExpense?()
    }
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
    }

    func deleteExpense(at index: Int) {
        guard expenses.indices.contains(index), let id = expenses[index].id else { return }
        MockAPIService.shared.deleteExpense(id: id) { [weak self] in
            DispatchQueue.main.async {
                self?.expenses.remove(at: index)
            }
        }
    }

}
