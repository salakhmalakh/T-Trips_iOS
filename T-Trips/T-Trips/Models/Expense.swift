//
//  Expense.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 26.05.2025.
//

import Foundation

struct Expense: Codable, Identifiable {
    let id: UUID
    let tripId: UUID
    let category: Category
    let amount: Double
    let userId: UUID
    let description: String?
    let createdAt: Date

    // MARK: - Coding Keys
    private enum CodingKeys: String, CodingKey {
        case id
        case tripId = "trip_id"
        case category
        case amount
        case userId = "user_id"
        case description
        case createdAt = "created_at"
    }

    // MARK: - Category Enum
    enum Category: String, Codable {
        case tickets = "TICKETS"
        case hotels = "HOTELS"
        case food = "FOOD"
        case entertainment = "ENTERTAINMENT"
        case insurance = "INSURANCE"
        case other = "OTHER"
    }
}

// MARK: - JSONDecoder Extension for ISO8601 Date Parsing
extension JSONDecoder {
    static var iso8601WithFractionalSeconds: JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            if let date = formatter.date(from: dateStr) {
                return date
            }
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date: \(dateStr)"
            )
        }
        return decoder
    }
}
