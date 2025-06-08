//
//  Debt.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 26.05.2025.
//

import Foundation

struct Debt: Codable, Identifiable {
    let id: Int
    let tripId: Int
    let userId: UUID
    let amount: Double
    let status: Status
    let createdAt: Date
    let updatedAt: Date?

    enum Status: String, Codable, CaseIterable {
        case pending = "PENDING"
        case paid = "PAID"
        case confirmed = "CONFIRMED"
        case cancelled = "CANCELLED"
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case tripId = "trip_id"
        case userId = "user_id"
        case amount
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
