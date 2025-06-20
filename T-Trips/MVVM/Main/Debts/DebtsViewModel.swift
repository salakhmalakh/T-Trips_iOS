import Foundation

import Combine

final class DebtsViewModel {
    @Published private(set) var debts: [Debt] = []

    private let tripId: Int64
    private let userId: Int64?

    private var tripStatus: Trip.Status?

    var isTripCompleted: Bool { tripStatus == .completed }

    init(tripId: Int64, userId: Int64? = nil) {
        self.tripId = tripId
        self.userId = userId
        loadTripStatus()
    }

    private func loadTripStatus() {
        MockAPIService.shared.getTrip(id: tripId) { [weak self] trip in
            DispatchQueue.main.async {
                self?.tripStatus = trip?.status
                self?.loadDebts()
            }
        }
    }

    func loadDebts() {
        MockAPIService.shared.getDebts(tripId: tripId, userId: userId) { [weak self] debts in
            DispatchQueue.main.async {
                self?.debts = debts
            }
        }
    }

    func payDebt(at index: Int) {
        guard isTripCompleted else { return }
        guard debts.indices.contains(index) else { return }
        let id = debts[index].debtId
        MockAPIService.shared.deleteDebt(id: id) { [weak self] in
            DispatchQueue.main.async {
                self?.debts.remove(at: index)
            }
        }
    }
}
