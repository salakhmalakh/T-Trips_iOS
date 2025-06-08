//
//  TripParticipant.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 26.05.2025.
//

import Foundation

struct TripParticipant: Codable, Identifiable {
    let id: UUID
    let tripId: UUID
    let userId: UUID
    let status: Status
    let joinedAt: Date
    let leftAt: Date?

    enum Status: String, Codable, CaseIterable {
        case pending = "PENDING"
        case accepted = "ACCEPTED"
        case rejected = "REJECTED"
        case left = "LEFT"
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case tripId = "trip_id"
        case userId = "user_id"
        case status
        case joinedAt = "joined_at"
        case leftAt = "left_at"
    }
}
