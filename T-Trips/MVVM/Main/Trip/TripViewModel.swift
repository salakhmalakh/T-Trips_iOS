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

    var isAdmin: Bool {
        NetworkAPIService.shared.currentUser?.id == trip.adminId
    }

    // MARK: - Handlers
    var onAddExpense: (() -> Void)?

    // MARK: - Init
    init(trip: Trip) {
        self.trip = trip
        loadExpenses()
    }

    // MARK: - Data Loading
    private func loadExpenses() {
        NetworkAPIService.shared.getExpenses(tripId: trip.id) { [weak self] expenses in
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
        guard isAdmin else { return }
        guard expenses.indices.contains(index), let id = expenses[index].id else { return }
        NetworkAPIService.shared.deleteExpense(id: id) { [weak self] in
            DispatchQueue.main.async {
                self?.expenses.remove(at: index)
            }
        }
    }

    func leaveTrip(completion: @escaping () -> Void) {
        guard let userId = NetworkAPIService.shared.currentUser?.id else { return }
        NetworkAPIService.shared.leaveTrip(tripId: trip.id, userId: userId) { _ in
            DispatchQueue.main.async { completion() }
        }
    }

}
