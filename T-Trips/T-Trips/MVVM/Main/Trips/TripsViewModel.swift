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
        let now = Date()
        trips = [
            // swiftlint:disable line_length
            Trip(
                id: UUID(),
                adminId: UUID(),
                title: "Отпуск в Сочи",
                startDate: now,
                endDate: Calendar.current.date(byAdding: .day, value: 7, to: now),
                budget: 100000,
                description: nil,
                status: .active,
                createdAt: now),
            Trip(id: UUID(), adminId: UUID(), title: "Поездка №1", startDate: now, endDate: Calendar.current.date(byAdding: .day, value: 5, to: now), budget: 50000, description: nil, status: .active, createdAt: now),
            Trip(id: UUID(), adminId: UUID(), title: "Поездка №2", startDate: now, endDate: Calendar.current.date(byAdding: .day, value: 3, to: now), budget: 30000, description: nil, status: .active, createdAt: now),
            Trip(id: UUID(), adminId: UUID(), title: "Поездка №3", startDate: now, endDate: Calendar.current.date(byAdding: .day, value: 10, to: now), budget: 120000, description: nil, status: .active, createdAt: now),
            Trip(id: UUID(), adminId: UUID(), title: "Поездка №4", startDate: now, endDate: Calendar.current.date(byAdding: .day, value: 2, to: now), budget: 20000, description: nil, status: .active, createdAt: now),
            Trip(id: UUID(), adminId: UUID(), title: "Поездка №5", startDate: now, endDate: Calendar.current.date(byAdding: .day, value: 14, to: now), budget: 150000, description: nil, status: .active, createdAt: now),
            Trip(id: UUID(), adminId: UUID(), title: "Поездка №6", startDate: now, endDate: Calendar.current.date(byAdding: .day, value: 4, to: now), budget: 40000, description: nil, status: .active, createdAt: now),
            Trip(id: UUID(), adminId: UUID(), title: "Поездка №7", startDate: now, endDate: Calendar.current.date(byAdding: .day, value: 8, to: now), budget: 80000, description: nil, status: .active, createdAt: now),
            Trip(id: UUID(), adminId: UUID(), title: "Поездка №8", startDate: now, endDate: Calendar.current.date(byAdding: .day, value: 6, to: now), budget: 60000, description: nil, status: .active, createdAt: now),
            Trip(id: UUID(), adminId: UUID(), title: "Поездка №9", startDate: now, endDate: Calendar.current.date(byAdding: .day, value: 9, to: now), budget: 90000, description: nil, status: .active, createdAt: now),
            Trip(id: UUID(), adminId: UUID(), title: "Поездка №10", startDate: now, endDate: Calendar.current.date(byAdding: .day, value: 1, to: now), budget: 25000, description: nil, status: .active, createdAt: now),
            Trip(
                id: UUID(),
                adminId: UUID(),
                title: "Горное восхождение",
                startDate: now,
                endDate: Calendar.current.date(byAdding: .day, value: 10, to: now),
                budget: 50000,
                description: nil,
                status: .planning,
                createdAt: now),
            Trip(
                id: UUID(),
                adminId: UUID(),
                title: "Бизнес-поездка",
                startDate: now.addingTimeInterval(-86400 * 30),
                endDate: now.addingTimeInterval(-86400 * 25),
                budget: 200000,
                description: nil,
                status: .completed,
                createdAt: now.addingTimeInterval(-86400 * 40))
            // swiftlint:enable line_length
        ]
    }
    func addTripTapped() { /* TODO */ }
}

private extension TripsViewModel.Filter {
    var correspondingStatus: TripStatus {
        switch self {
        case .active: return .active
        case .planning: return .planning
        case .completed: return .completed
        }
    }
}
