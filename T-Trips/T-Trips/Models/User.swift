//
//  User.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 23.05.2025.
//

import Foundation

// MARK: - User Model

enum UserStatus: String, Codable {
    case active   = "ACTIVE"
    case blocked  = "BLOCKED"
    case deleted  = "DELETED"
}

struct User: Codable {
    let id: UUID
    let login: String
    let phone: String
    let password: String
    let name: String?
    let surname: String?
    let status: UserStatus
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, login, phone, password, name, surname, status
        case createdAt = "created_at"
    }
}
