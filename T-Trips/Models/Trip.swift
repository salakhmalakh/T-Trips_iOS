//
//  Trip.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 23.05.2025.
//

import Foundation

// MARK: - Trip Model

struct Trip: Codable, Identifiable {
    let id: Int64
    let adminId: Int64
    let title: String
    let startDate: Date
    let endDate: Date
    let budget: Double
    let description: String?
    let status: Status
    let participantIds: [Int64]?

    enum Status: String, Codable, CaseIterable {
        case planning = "PLANNING"
        case active   = "ACTIVE"
        case completed = "COMPLETED"
        case deleted = "DELETED"
    }
}
