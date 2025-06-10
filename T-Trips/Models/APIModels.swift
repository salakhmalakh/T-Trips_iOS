import Foundation

struct TripDtoForCreate: Codable {
    let title: String
    let startDate: Date
    let endDate: Date
    let status: Trip.Status
    let budget: Double
    let description: String?
    let participantIds: [Int64]
}

struct ExpenseDtoForCreate: Codable {
    let category: Expense.Category
    let amount: Double
    let title: String
    let paidForUserIds: [Int64]
}
