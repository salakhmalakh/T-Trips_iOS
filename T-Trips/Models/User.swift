//
//  User.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 23.05.2025.
//

import Foundation

// MARK: - User Model

struct User: Codable, Identifiable {
    let id: UUID
    let login: String
    let phone: String
    let password: String
    let name: String
    let surname: String
    let status: Status
    let createdAt: Date

    enum Status: String, Codable, CaseIterable {
        case active = "ACTIVE"
        case blocked = "BLOCKED"
        case deleted = "DELETED"
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case login
        case phone
        case password
        case name
        case surname
        case status
        case createdAt = "created_at"
    }
}
