import Foundation

/// View model for the debt detail screen
final class DebtDetailViewModel {
    /// Creditor full name
    let creditorName: String
    /// Creditor phone or requisites
    let creditorPhone: String
    /// Trip title
    let tripTitle: String
    /// Text with amount value
    let amountText: String
    /// Should pay button be displayed
    let showsPayButton: Bool

    var onPay: (() -> Void)?

    init(debt: Debt, canPay: Bool) {
        let creditor = MockData.users.first { $0.id == debt.toUserId }
        let trip = MockData.trips.first { $0.id == debt.tripId }

        creditorName = [creditor?.firstName, creditor?.lastName]
            .compactMap { $0 }
            .joined(separator: " ")
        creditorPhone = creditor?.phone ?? ""
        tripTitle = trip?.title ?? ""
        amountText = debt.amount.rubleString
        showsPayButton = canPay && (MockAPIService.shared.currentUser?.id == debt.fromUserId)
    }

    func payTapped() {
        onPay?()
    }
}
