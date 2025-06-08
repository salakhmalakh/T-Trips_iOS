//
//  TripParticipant.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 26.05.2025.
//

import Foundation

struct TripParticipant: Codable, Identifiable {
    let id: Int64
    let tripId: Int64
    let userId: Int64
    let status: Status
    let joinedAt: Date
    let leftAt: Date?

    enum Status: String, Codable, CaseIterable {
        case pending = "PENDING"
        case accepted = "ACCEPTED"
        case rejected = "REJECTED"
        case left = "LEFT"
    }

}
