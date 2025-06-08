//
//  Expense.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 26.05.2025.
//

import Foundation

struct Expense: Codable, Identifiable {
    let id: Int64?
    let tripId: Int64
    let title: String
    let category: Category
    let amount: Double
    let ownerId: Int64
    let createdAt: Date?
    let paidForUserIds: [Int64]

    var owner: User? { MockData.users.first { $0.id == ownerId } }
    var paidForUsers: [User] { MockData.users.filter { paidForUserIds.contains($0.id) } }

    enum Category: String, Codable, CaseIterable {
        case tickets = "TICKETS"
        case longing = "LONGING"
        case food = "FOOD"
        case entertainment = "ENTERTAINMENT"
        case insurance = "INSURANCE"
        case transport = "TRANSPORT"
        case other = "OTHER"
    }
}

extension Expense.Category {
    var localized: String {
        switch self {
        case .tickets:
            return "Билеты"
        case .longing:
            return "Проживание"
        case .food:
            return "Еда"
        case .entertainment:
            return "Развлечения"
        case .insurance:
            return "Страховка"
        case .transport:
            return "Транспорт"
        case .other:
            return "Другое"
        }
    }
}
