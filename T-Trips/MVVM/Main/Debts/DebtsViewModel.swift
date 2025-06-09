import Foundation

import Combine

final class DebtsViewModel {
    @Published private(set) var debts: [Debt] = []

    private let tripId: Int64
    private let userId: Int64?

    init(tripId: Int64, userId: Int64? = nil) {
        self.tripId = tripId
        self.userId = userId
        loadDebts()
    }

    func loadDebts() {
        MockAPIService.shared.getDebts(tripId: tripId, userId: userId) { [weak self] debts in
            DispatchQueue.main.async {
                self?.debts = debts
            }
        }
    }

    func payDebt(at index: Int) {
        guard debts.indices.contains(index) else { return }
        let id = debts[index].debtId
        MockAPIService.shared.deleteDebt(id: id) { [weak self] in
            DispatchQueue.main.async {
                self?.debts.remove(at: index)
            }
        }
    }
}
