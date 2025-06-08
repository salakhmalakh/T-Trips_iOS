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
        // swiftlint:disable line_length
        User(id: UUID(), login: "ivanov", phone: "+79991234567", password: "password123", name: "Иван", surname: "Иванов", status: .active, createdAt: Date()),
        User(id: UUID(), login: "petrov", phone: "+79997654321", password: "securePass", name: "Пётр", surname: "Петров", status: .blocked, createdAt: Date().addingTimeInterval(-86400)),
        User(id: UUID(), login: "sidorov", phone: "+79990001122", password: "pass1234", name: "Сидор", surname: "Сидоров", status: .active, createdAt: Date().addingTimeInterval(-172800)),
        User(id: UUID(), login: "smirnova", phone: "+79993334455", password: "qwerty", name: "Анна", surname: "Смирнова", status: .active, createdAt: Date().addingTimeInterval(-259200)),
        User(id: UUID(), login: "orlov", phone: "+79992223344", password: "abc123", name: "Олег", surname: "Орлов", status: .deleted, createdAt: Date().addingTimeInterval(-345600)),
        User(id: UUID(), login: "fedorova", phone: "+79994445566", password: "letmein", name: "Мария", surname: "Фёдорова", status: .active, createdAt: Date().addingTimeInterval(-432000))
    ]

    static let trips: [Trip] = [
        Trip(id: UUID(), adminId: users[0].id, title: "Отпуск в Сочи", startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()), budget: 100000, description: "Море и пляж", status: .active, createdAt: Date()),
        Trip(id: UUID(), adminId: users[2].id, title: "Горное восхождение", startDate: Date().addingTimeInterval(-86400 * 10), endDate: Date().addingTimeInterval(-86400 * 3), budget: 75000, description: "Приключение в горах", status: .completed, createdAt: Date().addingTimeInterval(-86400 * 12)),
        Trip(id: UUID(), adminId: users[1].id, title: "Бизнес-поездка", startDate: Date().addingTimeInterval(-86400 * 30), endDate: Date().addingTimeInterval(-86400 * 25), budget: 200000, description: "Встречи с партнёрами", status: .planning, createdAt: Date().addingTimeInterval(-86400 * 40))
    ]

    static let participants: [TripParticipant] = [
        TripParticipant(id: UUID(), tripId: trips[0].id, userId: users[0].id, status: .accepted, joinedAt: Date().addingTimeInterval(-3600), leftAt: nil),
        TripParticipant(id: UUID(), tripId: trips[0].id, userId: users[1].id, status: .pending, joinedAt: Date().addingTimeInterval(-7200), leftAt: nil),
        TripParticipant(id: UUID(), tripId: trips[0].id, userId: users[2].id, status: .accepted, joinedAt: Date().addingTimeInterval(-10800), leftAt: nil),
        TripParticipant(id: UUID(), tripId: trips[1].id, userId: users[3].id, status: .accepted, joinedAt: Date().addingTimeInterval(-86400 * 11), leftAt: Date().addingTimeInterval(-86400 * 3)),
        TripParticipant(id: UUID(), tripId: trips[1].id, userId: users[4].id, status: .left, joinedAt: Date().addingTimeInterval(-86400 * 9), leftAt: Date().addingTimeInterval(-86400 * 5)),
        TripParticipant(id: UUID(), tripId: trips[2].id, userId: users[5].id, status: .pending, joinedAt: Date().addingTimeInterval(-86400 * 31), leftAt: nil)
    ]

    static let expenses: [Expense] = [
        Expense(id: UUID(), tripId: trips[0].id, category: .food, amount: 2500.75, userId: users[0].id, description: "Ужин в ресторане", createdAt: Date()),
        Expense(id: UUID(), tripId: trips[0].id, category: .hotels, amount: 5000, userId: users[1].id, description: nil, createdAt: Date().addingTimeInterval(-18000)),
        Expense(id: UUID(), tripId: trips[0].id, category: .tickets, amount: 15000, userId: users[2].id, description: "Авиа билеты", createdAt: Date().addingTimeInterval(-36000)),
        Expense(id: UUID(), tripId: trips[0].id, category: .entertainment, amount: 3000, userId: users[0].id, description: "Экскурсия", createdAt: Date().addingTimeInterval(-54000)),
        Expense(id: UUID(), tripId: trips[1].id, category: .insurance, amount: 2000, userId: users[3].id, description: "Страховка", createdAt: Date().addingTimeInterval(-86400 * 10)),
        Expense(id: UUID(), tripId: trips[1].id, category: .other, amount: 1200, userId: users[4].id, description: "Мелкие расходы", createdAt: Date().addingTimeInterval(-86400 * 9)),
        Expense(id: UUID(), tripId: trips[2].id, category: .food, amount: 8000, userId: users[5].id, description: "Деловой обед", createdAt: Date().addingTimeInterval(-86400 * 29))
    ]

    static let debts: [Debt] = [
        Debt(id: 1, tripId: 1, userId: users[1].id, amount: 1250.37, status: .pending, createdAt: Date(), updatedAt: nil),
        Debt(id: 2, tripId: 1, userId: users[2].id, amount: 500, status: .confirmed, createdAt: Date().addingTimeInterval(-10000), updatedAt: Date().addingTimeInterval(-5000)),
        Debt(id: 3, tripId: 2, userId: users[3].id, amount: 300, status: .paid, createdAt: Date().addingTimeInterval(-86400 * 10), updatedAt: Date().addingTimeInterval(-86400 * 5))
    ]

    static let notifications: [NotificationItem] = [
        NotificationItem(id: 1, userId: 1, tripId: trips[0].id.hashValue, type: .invitation, message: "Вас добавили в поездку 'Отпуск в Сочи'", status: .unread, createdAt: Date()),
        NotificationItem(id: 2, userId: 2, tripId: trips[1].id.hashValue, type: .expenseAdded, message: "Новый расход добавлен", status: .read, createdAt: Date().addingTimeInterval(-20000)),
        NotificationItem(id: 3, userId: 5, tripId: trips[2].id.hashValue, type: .debtCreated, message: "У вас новый долг", status: .archived, createdAt: Date().addingTimeInterval(-40000))
    ]
    // swiftlint:enable line_length
}
