//
//  Trip.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 23.05.2025.
//

import Foundation

// MARK: - Trip Model

enum TripStatus: String, Codable {
    case planning  = "PLANNING"
    case active    = "ACTIVE"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
}

struct Trip: Codable {
    let id: UUID
    let adminId: UUID
    let title: String
    let startDate: Date
    let endDate: Date?
    let budget: Double?
    let description: String?
    let status: TripStatus
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case adminId     = "admin_id"
        case title
        case startDate   = "start_date"
        case endDate     = "end_date"
        case budget, description, status
        case createdAt   = "created_at"
    }
}
