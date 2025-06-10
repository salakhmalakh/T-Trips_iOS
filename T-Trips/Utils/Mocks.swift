//
//  Mocks.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 26.05.2025.
//

import Foundation

// MARK: - Mocks
enum MockData {
    static let users: [User] = [
        User(id: 1, phone: "+79991234567", firstName: "Иван", lastName: "Иванов", hashPassword: "password123", status: .active, role: .user, active: true),
        User(id: 2, phone: "+79997654321", firstName: "Пётр", lastName: "Петров", hashPassword: "securePass", status: .active, role: .user, active: true),
        User(id: 3, phone: "+79990001122", firstName: "Сидор", lastName: "Сидоров", hashPassword: "pass1234", status: .active, role: .user, active: true),
        User(id: 4, phone: "+79993334455", firstName: "Анна", lastName: "Смирнова", hashPassword: "qwerty", status: .active, role: .user, active: true),
        User(id: 5, phone: "+79992223344", firstName: "Олег", lastName: "Орлов", hashPassword: "abc123", status: .deleted, role: .user, active: false),
        User(id: 6, phone: "+79994445566", firstName: "Мария", lastName: "Фёдорова", hashPassword: "letmein", status: .active, role: .user, active: true)
    ]

    static let trips: [Trip] = [
        Trip(id: 1, adminId: users[0].id, title: "Отпуск в Сочи", startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(), budget: 100000, description: "Море и пляж", status: .active, participantIds: [users[0].id, users[2].id]),
        Trip(id: 2, adminId: users[2].id, title: "Горное восхождение", startDate: Date().addingTimeInterval(-86400 * 10), endDate: Date().addingTimeInterval(-86400 * 3), budget: 75000, description: "Приключение в горах", status: .completed, participantIds: [users[2].id, users[3].id, users[4].id]),
        Trip(id: 3, adminId: users[1].id, title: "Бизнес-поездка", startDate: Date().addingTimeInterval(-86400 * 30), endDate: Date().addingTimeInterval(-86400 * 25), budget: 200000, description: "Встречи с партнёрами", status: .planning, participantIds: [users[1].id])
    ]

    static let participants: [TripParticipant] = [
        TripParticipant(id: 1, tripId: trips[0].id, userId: users[0].id, status: .accepted, joinedAt: Date().addingTimeInterval(-3600), leftAt: nil),
        TripParticipant(id: 2, tripId: trips[0].id, userId: users[1].id, status: .pending, joinedAt: Date().addingTimeInterval(-7200), leftAt: nil),
        TripParticipant(id: 3, tripId: trips[0].id, userId: users[2].id, status: .accepted, joinedAt: Date().addingTimeInterval(-10800), leftAt: nil),
        TripParticipant(id: 4, tripId: trips[1].id, userId: users[3].id, status: .accepted, joinedAt: Date().addingTimeInterval(-86400 * 11), leftAt: Date().addingTimeInterval(-86400 * 3)),
        TripParticipant(id: 5, tripId: trips[1].id, userId: users[4].id, status: .left, joinedAt: Date().addingTimeInterval(-86400 * 9), leftAt: Date().addingTimeInterval(-86400 * 5)),
        TripParticipant(id: 6, tripId: trips[2].id, userId: users[5].id, status: .pending, joinedAt: Date().addingTimeInterval(-86400 * 31), leftAt: nil)
    ]

    static let expenses: [Expense] = [
        Expense(id: 1, tripId: trips[0].id, title: "Ужин в ресторане", category: .food, amount: 2500.75, ownerId: users[0].id, createdAt: Date(), paidForUserIds: [users[1].id]),
        Expense(id: 2, tripId: trips[0].id, title: "Отель", category: .longing, amount: 5000, ownerId: users[1].id, createdAt: Date().addingTimeInterval(-18000), paidForUserIds: [users[0].id]),
        Expense(id: 3, tripId: trips[0].id, title: "Авиа билеты", category: .tickets, amount: 15000, ownerId: users[2].id, createdAt: Date().addingTimeInterval(-36000), paidForUserIds: [users[2].id]),
        Expense(id: 4, tripId: trips[0].id, title: "Экскурсия", category: .entertainment, amount: 3000, ownerId: users[0].id, createdAt: Date().addingTimeInterval(-54000), paidForUserIds: [users[1].id, users[2].id]),
        Expense(id: 5, tripId: trips[1].id, title: "Страховка", category: .insurance, amount: 2000, ownerId: users[3].id, createdAt: Date().addingTimeInterval(-86400 * 10), paidForUserIds: [users[3].id]),
        Expense(id: 6, tripId: trips[1].id, title: "Мелкие расходы", category: .other, amount: 1200, ownerId: users[4].id, createdAt: Date().addingTimeInterval(-86400 * 9), paidForUserIds: [users[4].id]),
        Expense(id: 7, tripId: trips[2].id, title: "Деловой обед", category: .food, amount: 8000, ownerId: users[5].id, createdAt: Date().addingTimeInterval(-86400 * 29), paidForUserIds: [users[5].id])
    ]

    static let debts: [Debt] = [
        Debt(debtId: "1", tripId: trips[0].id, fromUserId: users[1].id, toUserId: users[0].id, amount: 1250.37, debtStatus: .pending),
        Debt(debtId: "2", tripId: trips[0].id, fromUserId: users[2].id, toUserId: users[0].id, amount: 500, debtStatus: .pending),
        Debt(debtId: "3", tripId: trips[1].id, fromUserId: users[3].id, toUserId: users[2].id, amount: 300, debtStatus: .pending)
    ]

    static let notifications: [NotificationItem] = [
        NotificationItem(id: 1, userId: 2, tripId: trips[0].id, type: .invitation, message: "Иван Иванов приглашает вас в событие Отпуск в Сочи", status: .unread, createdAt: Date()),
        NotificationItem(id: 2, userId: 2, tripId: trips[1].id, type: .expenseAdded, message: "Новый расход добавлен", status: .read, createdAt: Date().addingTimeInterval(-20000)),
        NotificationItem(id: 3, userId: 5, tripId: trips[2].id, type: .debtCreated, message: "У вас новый долг", status: .archived, createdAt: Date().addingTimeInterval(-40000))
    ]
    // swiftlint:enable line_length
}
