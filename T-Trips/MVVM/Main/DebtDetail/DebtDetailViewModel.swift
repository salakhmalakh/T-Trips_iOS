import Foundation

final class DebtDetailViewModel {
    let infoText: String

    init(debt: Debt) {
        infoText = "Должник: \(debt.fromUserId)\nПолучатель: \(debt.toUserId)\nСумма: \(debt.amount)₽"
    }
}
