import Foundation

/// View model for the debt detail screen
final class DebtDetailViewModel {
    /// Text with participants (debtor -> creditor)
    let participantsText: String
    /// Text with amount value
    let amountText: String
    /// Should pay button be displayed
    let showsPayButton: Bool

    var onPay: (() -> Void)?

    init(debt: Debt) {
        let fromUser = MockData.users.first { $0.id == debt.fromUserId }
        let toUser = MockData.users.first { $0.id == debt.toUserId }
        let fromName = [fromUser?.firstName, fromUser?.lastName].compactMap { $0 }.joined(separator: " ")
        let toName = [toUser?.firstName, toUser?.lastName].compactMap { $0 }.joined(separator: " ")
        participantsText = "\(fromName) → \(toName)"
        amountText = debt.amount.rubleString
        showsPayButton = MockAPIService.shared.currentUser?.id == debt.fromUserId
    }

    func payTapped() {
        onPay?()
    }
}
