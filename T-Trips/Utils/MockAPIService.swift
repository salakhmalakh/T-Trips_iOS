import Foundation

final class MockAPIService {
    static let shared = MockAPIService()

    private var trips: [Trip]
    private var expenses: [Expense]
    private var debts: [Debt]
    private var users: [User]

    private init() {
        self.trips = MockData.trips
        self.expenses = MockData.expenses
        self.debts = MockData.debts
        self.users = MockData.users
    }

    // MARK: - Trips
    func getUserTrips(status: Trip.Status, completion: @escaping ([Trip]) -> Void) {
        asyncDelay {
            let result = self.trips.filter { $0.status == status }
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
                participantIds: dto.participantIds
            )
            self.trips.append(trip)
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

    // MARK: - Participants
    func findParticipant(phone: String, completion: @escaping (User?) -> Void) {
        asyncDelay {
            completion(self.users.first { $0.phone == phone })
        }
    }

    // MARK: - Auth
    func authenticate(phone: String, password: String, completion: @escaping (Bool) -> Void) {
        asyncDelay {
            let user = self.users.first { $0.phone == phone && $0.hashPassword == password }
            completion(user != nil)
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
