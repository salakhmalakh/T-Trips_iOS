//
//  Debt.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 26.05.2025.
//

import Foundation

struct Debt: Codable, Identifiable {
    let debtId: String
    let tripId: Int64
    let fromUserId: Int64
    let toUserId: Int64
    let amount: Double
    var debtStatus: Status

    var id: String { debtId }

    enum Status: String, Codable, CaseIterable {
        case pending = "PENDING"
        case payed = "PAYED"
    }

    private enum CodingKeys: String, CodingKey {
        case debtId
        case tripId
        case fromUserId
        case toUserId
        case amount
        case debtStatus
    }
}
