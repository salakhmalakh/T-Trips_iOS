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
    /// Login or phone number used for authentication
    let login: String
    let password: String
}

/// Request payload for the register endpoint.
struct RegisterRequest: Codable {
    let login: String
    let phone: String
    let password: String
    let name: String
    let surname: String
}

/// Response with JWT access and refresh tokens.
struct JwtTokenPair: Codable {
    let accessToken: String
    let refreshToken: String
}

/// Request payload for token refresh endpoint.
struct RefreshTokenRequest: Codable {
    let refreshToken: String
}

