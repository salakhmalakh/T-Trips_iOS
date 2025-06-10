import Foundation

final class MockAPIService {
    static let shared = MockAPIService()

    private var trips: [Trip]
    private var expenses: [Expense]
    private var debts: [Debt]
    private var users: [User]
    private var notifications: [NotificationItem]
    private var participants: [TripParticipant]
    private var currentUserId: Int64?

    private init() {
        self.trips = MockData.trips
        self.expenses = MockData.expenses
        self.debts = MockData.debts
        self.users = MockData.users
        self.notifications = MockData.notifications
        self.participants = MockData.participants
    }

    var currentUser: User? {
        users.first { $0.id == currentUserId }
    }

    // MARK: - Trips
    func getUserTrips(status: Trip.Status, completion: @escaping ([Trip]) -> Void) {
        asyncDelay {
            guard let uid = self.currentUserId else {
                completion([])
                return
            }
            let acceptedTripIds = self.participants
                .filter { $0.userId == uid && $0.status == .accepted }
                .map { $0.tripId }
            let result = self.trips.filter { trip in
                trip.status == status &&
                (trip.adminId == uid || acceptedTripIds.contains(trip.id))
            }
            completion(result)
        }
    }

    func getTrip(id: Int64, completion: @escaping (Trip?) -> Void) {
        asyncDelay {
            completion(self.trips.first { $0.id == id })
        }
    }

    func createTrip(_ dto: TripDtoForCreate, adminId: Int64, completion: @escaping (Trip) -> Void) {
        asyncDelay {
            let newId = (self.trips.map { $0.id }.max() ?? 0) + 1
            let trip = Trip(
                id: newId,
                adminId: adminId,
                title: dto.title,
                startDate: dto.startDate,
                endDate: dto.endDate,
                budget: dto.budget,
                description: dto.description,
                status: dto.status,
                participantIds: [adminId]
            )
            self.trips.append(trip)

            // create participants and notifications
            var nextParticipantId = (self.participants.map { $0.id }.max() ?? 0) + 1
            var nextNotificationId = (self.notifications.map { $0.id }.max() ?? 0) + 1
            for uid in dto.participantIds where uid != adminId {
                let participant = TripParticipant(
                    id: Int64(nextParticipantId),
                    tripId: newId,
                    userId: uid,
                    status: .pending,
                    joinedAt: Date(),
                    leftAt: nil
                )
                self.participants.append(participant)
                nextParticipantId += 1

                if let admin = self.users.first(where: { $0.id == adminId }) {
                    let message = "\(admin.firstName) \(admin.lastName) приглашает вас в событие \(dto.title)"
                    let notification = NotificationItem(
                        id: nextNotificationId,
                        userId: uid,
                        tripId: newId,
                        type: .invitation,
                        message: message,
                        status: .unread,
                        createdAt: Date()
                    )
                    self.notifications.append(notification)
                    nextNotificationId += 1
                }
            }

            completion(trip)
        }
    }

    // MARK: - Expenses
    func getExpenses(tripId: Int64, completion: @escaping ([Expense]) -> Void) {
        asyncDelay {
            completion(self.expenses.filter { $0.tripId == tripId })
        }
    }

    func createExpense(tripId: Int64, dto: ExpenseDtoForCreate, ownerId: Int64, completion: @escaping (Expense) -> Void) {
        asyncDelay {
            let newId = (self.expenses.map { $0.id ?? 0 }.max() ?? 0) + 1
            let expense = Expense(
                id: newId,
                tripId: tripId,
                title: dto.title,
                category: dto.category,
                amount: dto.amount,
                ownerId: ownerId,
                createdAt: Date(),
                paidForUserIds: dto.paidForUserIds
            )
            self.expenses.append(expense)

            let payees = dto.paidForUserIds.filter { $0 != ownerId }
            if !payees.isEmpty {
                let partAmount = dto.amount / Double(dto.paidForUserIds.count)
                for uid in payees {
                    let debt = Debt(
                        debtId: UUID().uuidString,
                        tripId: tripId,
                        fromUserId: uid,
                        toUserId: ownerId,
                        amount: partAmount
                    )
                    self.debts.append(debt)
                }
            }

            completion(expense)
        }
    }

    func deleteExpense(id: Int64, completion: @escaping () -> Void) {
        asyncDelay {
            self.expenses.removeAll { $0.id == id }
            completion()
        }
    }

    // MARK: - Debts
    func getDebts(tripId: Int64, userId: Int64?, completion: @escaping ([Debt]) -> Void) {
        asyncDelay {
            var result = self.debts.filter { $0.tripId == tripId }
            if let uid = userId {
                result = result.filter { $0.fromUserId == uid || $0.toUserId == uid }
            }
            completion(result)
        }
    }

    func deleteDebt(id: String, completion: @escaping () -> Void) {
        asyncDelay {
            self.debts.removeAll { $0.debtId == id }
            completion()
        }
    }

    // MARK: - Participants
    func findParticipant(phone: String, completion: @escaping (User?) -> Void) {
        asyncDelay {
            completion(self.users.first { $0.phone == phone })
        }
    }

    func leaveTrip(tripId: Int64, userId: Int64, completion: @escaping (Trip?) -> Void) {
        asyncDelay {
            guard let index = self.trips.firstIndex(where: { $0.id == tripId }) else {
                completion(nil)
                return
            }
            var participantIds = self.trips[index].participantIds ?? []
            participantIds.removeAll { $0 == userId }

            var adminId = self.trips[index].adminId
            if adminId == userId, let newAdmin = participantIds.first {
                adminId = newAdmin
            }

            let updatedTrip = Trip(
                id: self.trips[index].id,
                adminId: adminId,
                title: self.trips[index].title,
                startDate: self.trips[index].startDate,
                endDate: self.trips[index].endDate,
                budget: self.trips[index].budget,
                description: self.trips[index].description,
                status: self.trips[index].status,
                participantIds: participantIds
            )
            self.trips[index] = updatedTrip
            completion(updatedTrip)
        }
    }

    // MARK: - Auth
    func authenticate(phone: String, password: String, completion: @escaping (Bool) -> Void) {
        asyncDelay {
            let user = self.users.first { $0.phone == phone && $0.hashPassword == password }
            self.currentUserId = user?.id
            completion(user != nil)
        }
    }

    func register(phone: String, firstName: String, lastName: String, password: String, completion: @escaping (Bool) -> Void) {
        asyncDelay {
            guard self.users.first(where: { $0.phone == phone }) == nil else {
                completion(false)
                return
            }
            let newId = (self.users.map { $0.id }.max() ?? 0) + 1
            let user = User(
                id: newId,
                phone: phone,
                firstName: firstName,
                lastName: lastName,
                hashPassword: password,
                status: .active,
                role: .user,
                active: true
            )
            self.users.append(user)
            self.currentUserId = user.id
            completion(true)
        }
    }
}

private extension MockAPIService {
    func asyncDelay(_ block: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3, execute: block)
    }
}

// MARK: - DTOs
struct TripDtoForCreate {
    let title: String
    let startDate: Date
    let endDate: Date
    let status: Trip.Status
    let budget: Double
    let description: String?
    let participantIds: [Int64]
}

struct ExpenseDtoForCreate {
    let category: Expense.Category
    let amount: Double
    let title: String
    let paidForUserIds: [Int64]
}

// MARK: - User management
extension MockAPIService {
    func updateCurrentUser(firstName: String, lastName: String, phone: String, completion: @escaping (User?) -> Void) {
        asyncDelay {
            guard let id = self.currentUserId, let index = self.users.firstIndex(where: { $0.id == id }) else {
                completion(nil)
                return
            }
            let user = User(
                id: id,
                phone: phone,
                firstName: firstName,
                lastName: lastName,
                hashPassword: self.users[index].hashPassword,
                status: self.users[index].status,
                role: self.users[index].role,
                active: self.users[index].active
            )
            self.users[index] = user
            completion(user)
        }
    }

    func getNotifications(completion: @escaping ([NotificationItem]) -> Void) {
        asyncDelay {
            guard let id = self.currentUserId else {
                completion([])
                return
            }
            completion(self.notifications.filter { $0.userId == id })
        }
    }

    func respondToInvitation(notificationId: Int, accept: Bool, completion: @escaping () -> Void) {
        asyncDelay {
            guard let index = self.notifications.firstIndex(where: { $0.id == notificationId }) else {
                completion()
                return
            }
            let note = self.notifications.remove(at: index)
            guard let tripId = note.tripId else { completion(); return }
            if accept {
                if let tIndex = self.trips.firstIndex(where: { $0.id == tripId }) {
                    var ids = self.trips[tIndex].participantIds ?? []
                    if !ids.contains(note.userId) { ids.append(note.userId) }
                    let trip = Trip(
                        id: self.trips[tIndex].id,
                        adminId: self.trips[tIndex].adminId,
                        title: self.trips[tIndex].title,
                        startDate: self.trips[tIndex].startDate,
                        endDate: self.trips[tIndex].endDate,
                        budget: self.trips[tIndex].budget,
                        description: self.trips[tIndex].description,
                        status: self.trips[tIndex].status,
                        participantIds: ids
                    )
                    self.trips[tIndex] = trip
                }
                if let pIndex = self.participants.firstIndex(where: { $0.tripId == tripId && $0.userId == note.userId }) {
                    let participants = self.participants[pIndex]
                    self.participants[pIndex] = TripParticipant(id: participants.id, tripId: participants.tripId, userId: participants.userId, status: .accepted, joinedAt: participants.joinedAt, leftAt: participants.leftAt)
                }
            } else {
                if let pIndex = self.participants.firstIndex(where: { $0.tripId == tripId && $0.userId == note.userId }) {
                    let participants = self.participants[pIndex]
                    self.participants[pIndex] = TripParticipant(id: participants.id, tripId: participants.tripId, userId: participants.userId, status: .rejected, joinedAt: participants.joinedAt, leftAt: participants.leftAt)
                }
            }
            completion()
        }
    }

    func logout() {
        currentUserId = nil
    }
}
