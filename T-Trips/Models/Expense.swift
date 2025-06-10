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

    var owner: User? {
        NetworkAPIService.shared.usersCache.first { $0.id == ownerId }
    }

    var paidForUsers: [User] {
        NetworkAPIService.shared.usersCache.filter { paidForUserIds.contains($0.id) }
    }

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
            return "tickets".localized
        case .longing:
            return "longing".localized
        case .food:
            return "food".localized
        case .entertainment:
            return "entertainment".localized
        case .insurance:
            return "insurance".localized
        case .transport:
            return "transport".localized
        case .other:
            return "other".localized
        }
    }

    /// SF Symbol name associated with the expense category
    var symbolName: String {
        switch self {
        case .tickets:
            return "ticket.fill"
        case .longing:
            return "bed.double.fill"
        case .food:
            return "fork.knife"
        case .entertainment:
            return "gamecontroller.fill"
        case .insurance:
            return "shield.fill"
        case .transport:
            return "car.fill"
        case .other:
            return "ellipsis.circle"
        }
    }
}
