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

    init(debt: Debt, users: [User], tripTitle: String, canPay: Bool) {
        let creditor = users.first { $0.id == debt.toUserId }

        creditorName = [creditor?.firstName, creditor?.lastName]
            .compactMap { $0 }
            .joined(separator: " ")
        creditorPhone = creditor?.phone ?? ""
        self.tripTitle = tripTitle
        amountText = debt.amount.rubleString
        showsPayButton = canPay && (NetworkAPIService.shared.currentUser?.id == debt.fromUserId)
    }

    func payTapped() {
        onPay?()
    }
}
