//
//  Notification.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 26.05.2025.
//

import Foundation

struct NotificationItem: Codable, Identifiable {
    let id: Int
    let userId: Int64
    let tripId: Int64?
    let type: NotificationType
    let message: String
    let status: Status
    let createdAt: Date

    enum NotificationType: String, Codable, CaseIterable {
        case invitation = "INVITATION"
        case expenseAdded = "EXPENSE_ADDED"
        case debtCreated = "DEBT_CREATED"
        case tripUpdated = "TRIP_UPDATED"
    }
    enum Status: String, Codable, CaseIterable {
        case unread = "UNREAD"
        case read = "READ"
        case archived = "ARCHIVED"
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case tripId = "trip_id"
        case type
        case message
        case status
        case createdAt = "created_at"
    }
}
