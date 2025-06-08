//
//  TripsViewModel.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 23.05.2025.
//

import Foundation
import Combine

final class TripsViewModel {
    enum Filter: Int, CaseIterable {
        case active = 0, planning, completed
        var title: String {
            switch self {
            case .active: return "Активные"
            case .planning: return "Запланированные"
            case .completed: return "Завершенные"
            }
        }
    }

    // Inputs
    @Published var filter: Filter = .active

    // Outputs
    @Published private(set) var trips: [Trip] = []
    @Published private(set) var filteredTrips: [Trip] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadTrips()
        Publishers.CombineLatest($trips, $filter)
            .map { trips, filter in trips.filter { $0.status == filter.correspondingStatus } }
            .receive(on: RunLoop.main)
            .assign(to: \ .filteredTrips, on: self)
            .store(in: &cancellables)
    }
    func loadTrips() {
        // TODO: заменить на API
        self.trips = MockData.trips
    }

    func addTripTapped() { /* TODO */ }
}

private extension TripsViewModel.Filter {
    var correspondingStatus: Trip.Status {
        switch self {
        case .active: return .active
        case .planning: return .planning
        case .completed: return .completed
        }
    }
}
