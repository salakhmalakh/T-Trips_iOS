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
            case .active: return "active".localized
            case .planning: return "planning".localized
            case .completed: return "completed".localized
            }
        }
    }

    // Inputs
    @Published var filter: Filter = .active

    // Outputs
    @Published private(set) var trips: [Trip] = []
    @Published private(set) var filteredTrips: [Trip] = []

    // Handlers
    var onAddTrip: (() -> Void)?

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadTrips(for: filter)

        $filter
            .sink { [weak self] newFilter in
                self?.loadTrips(for: newFilter)
            }
            .store(in: &cancellables)

        Publishers.CombineLatest($trips, $filter)
            .map { trips, filter in
                trips.filter { $0.status == filter.correspondingStatus }
            }
            .receive(on: RunLoop.main)
            .assign(to: \ .filteredTrips, on: self)
            .store(in: &cancellables)
    }
    func loadTrips(for filter: Filter) {
        MockAPIService.shared.getUserTrips(status: filter.correspondingStatus) { [weak self] trips in
            DispatchQueue.main.async {
                self?.trips = trips
            }
        }
    }

    func addTripTapped() { onAddTrip?() }

    func addTrip(_ trip: Trip) {
        trips.append(trip)
    }
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
