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
    let role: Role
    let active: Bool

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
        case firstName
        case lastName
        case hashPassword
        case status
        case role
        case active
    }
}
