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

/// Request payload for the login endpoint.
struct LoginRequest: Codable {
    let phone: String
    let password: String
}

/// Request payload for the register endpoint.
struct RegisterRequest: Codable {
    let phone: String
    let firstName: String
    let lastName: String
    let password: String
}

