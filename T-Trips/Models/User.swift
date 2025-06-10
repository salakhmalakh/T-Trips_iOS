//
//  User.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 23.05.2025.
//

import Foundation

// MARK: - User Model

struct User: Codable, Identifiable {
    let id: Int64
    let phone: String
    let firstName: String
    let lastName: String
    let hashPassword: String
    let status: Status
    let role: Role?
    let active: Bool?
    let createdAt: Date?

    enum Status: String, Codable, CaseIterable {
        case active = "ACTIVE"
        case deleted = "DELETED"
    }

    enum Role: String, Codable, CaseIterable {
        case user = "USER"
        case admin = "ADMIN"
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case phone
        case firstName = "name"
        case lastName = "surname"
        case hashPassword = "password"
        case status
        case role
        case active
        case createdAt = "created_at"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        phone = try container.decode(String.self, forKey: .phone)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        hashPassword = try container.decodeIfPresent(String.self, forKey: .hashPassword) ?? ""
        status = try container.decode(Status.self, forKey: .status)
        role = try container.decodeIfPresent(Role.self, forKey: .role)
        active = try container.decodeIfPresent(Bool.self, forKey: .active)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
    }
}
