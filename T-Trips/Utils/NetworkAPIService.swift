import Foundation

/// Service for communicating with the real backend.
/// Currently only includes a couple of implemented methods.
final class NetworkAPIService {
    static let shared = NetworkAPIService()

    /// Base URL for the backend API.
    private let baseURL = URL(string: "http://82.202.136.132:8082")!
    private let session: URLSession
    private(set) var currentUser: User?

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Auth
    func authenticate(phone: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = baseURL.appendingPathComponent("/auth/login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(phone: phone, password: password)
        request.httpBody = try? JSONEncoder().encode(body)

        let task = session.dataTask(with: request) { data, response, _ in
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode)
            else {
                completion(false)
                return
            }

            if let data = data,
               let user = try? JSONDecoder.apiDecoder.decode(User.self, from: data) {
                self.currentUser = user
            }
            completion(true)
        }
        task.resume()
    }

    enum RegisterError: Error {
        case phoneExists
        case unknown
    }

    func register(phone: String, firstName: String, lastName: String, password: String, completion: @escaping (Result<Void, RegisterError>) -> Void) {
        let url = baseURL.appendingPathComponent("/auth/register")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = RegisterRequest(phone: phone, firstName: firstName, lastName: lastName, password: password)
        request.httpBody = try? JSONEncoder().encode(body)

        let task = session.dataTask(with: request) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }
            switch httpResponse.statusCode {
            case 200..<300:
                if let data = data,
                   let user = try? JSONDecoder.apiDecoder.decode(User.self, from: data) {
                    self.currentUser = user
                }
                completion(.success(()))
            case 409:
                completion(.failure(.phoneExists))
            default:
                completion(.failure(.unknown))
            }
        }
        task.resume()
    }

    // MARK: - Trips
    func getUserTrips(status: Trip.Status, completion: @escaping ([Trip]) -> Void) {
        var components = URLComponents(url: baseURL.appendingPathComponent("/trips"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "status", value: status.rawValue)]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request) { data, response, _ in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let trips = try? JSONDecoder.apiDecoder.decode([Trip].self, from: data)
            else {
                completion([])
                return
            }
            completion(trips)
        }
        task.resume()
    }

    func getTrip(id: Int64, completion: @escaping (Trip?) -> Void) {
        let url = baseURL.appendingPathComponent("/trips/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request) { data, response, _ in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let trip = try? JSONDecoder.apiDecoder.decode(Trip.self, from: data)
            else {
                completion(nil)
                return
            }
            completion(trip)
        }
        task.resume()
    }

    func createTrip(_ dto: TripDtoForCreate, adminId: Int64, completion: @escaping (Trip?) -> Void) {
        let url = baseURL.appendingPathComponent("/trips")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let payload: [String: Any] = [
            "title": dto.title,
            "startDate": ISO8601DateFormatter().string(from: dto.startDate),
            "endDate": ISO8601DateFormatter().string(from: dto.endDate),
            "status": dto.status.rawValue,
            "budget": dto.budget,
            "description": dto.description as Any,
            "participantIds": dto.participantIds,
            "adminId": adminId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])

        let task = session.dataTask(with: request) { data, response, _ in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let trip = try? JSONDecoder.apiDecoder.decode(Trip.self, from: data)
            else {
                completion(nil)
                return
            }
            completion(trip)
        }
        task.resume()
    }

    func updateTrip(_ trip: Trip, completion: @escaping (Trip?) -> Void) {
        let url = baseURL.appendingPathComponent("/trips/\(trip.id)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(trip)

        let task = session.dataTask(with: request) { data, response, _ in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let updated = try? JSONDecoder.apiDecoder.decode(Trip.self, from: data)
            else {
                completion(nil)
                return
            }
            completion(updated)
        }
        task.resume()
    }

    func leaveTrip(tripId: Int64, userId: Int64, completion: @escaping (Trip?) -> Void) {
        let url = baseURL.appendingPathComponent("/trips/\(tripId)/leave")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["userId": userId])

        let task = session.dataTask(with: request) { data, response, _ in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode)
            else {
                completion(nil)
                return
            }
            let trip = try? JSONDecoder.apiDecoder.decode(Trip.self, from: data)
            completion(trip)
        }
        task.resume()
    }

    // MARK: - Expenses
    func getExpenses(tripId: Int64, completion: @escaping ([Expense]) -> Void) {
        let url = baseURL.appendingPathComponent("/trips/\(tripId)/expenses")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request) { data, response, _ in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let expenses = try? JSONDecoder.apiDecoder.decode([Expense].self, from: data)
            else {
                completion([])
                return
            }
            completion(expenses)
        }
        task.resume()
    }

    func createExpense(tripId: Int64, dto: ExpenseDtoForCreate, ownerId: Int64, completion: @escaping (Expense?) -> Void) {
        let url = baseURL.appendingPathComponent("/trips/\(tripId)/expenses")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONEncoder().encode(dto)

        let task = session.dataTask(with: request) { data, response, _ in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let expense = try? JSONDecoder.apiDecoder.decode(Expense.self, from: data)
            else {
                completion(nil)
                return
            }
            completion(expense)
        }
        task.resume()
    }

    func deleteExpense(id: Int64, completion: @escaping () -> Void) {
        let url = baseURL.appendingPathComponent("/expenses/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let task = session.dataTask(with: request) { _, response, _ in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                completion()
                return
            }
            completion()
        }
        task.resume()
    }

    // MARK: - Debts
    func getDebts(tripId: Int64, userId: Int64?, completion: @escaping ([Debt]) -> Void) {
        var components = URLComponents(url: baseURL.appendingPathComponent("/trips/\(tripId)/debts"), resolvingAgainstBaseURL: false)!
        if let uid = userId {
            components.queryItems = [URLQueryItem(name: "userId", value: String(uid))]
        }
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request) { data, response, _ in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let debts = try? JSONDecoder.apiDecoder.decode([Debt].self, from: data)
            else {
                completion([])
                return
            }
            completion(debts)
        }
        task.resume()
    }

    func deleteDebt(id: String, completion: @escaping () -> Void) {
        let url = baseURL.appendingPathComponent("/debts/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let task = session.dataTask(with: request) { _, response, _ in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                completion()
                return
            }
            completion()
        }
        task.resume()
    }

    // MARK: - Participants
    func findParticipant(phone: String, completion: @escaping (User?) -> Void) {
        var components = URLComponents(url: baseURL.appendingPathComponent("/participants/find"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "phone", value: phone)]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request) { data, response, _ in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode)
            else {
                completion(nil)
                return
            }
            let user = try? JSONDecoder.apiDecoder.decode(User.self, from: data)
            completion(user)
        }
        task.resume()
    }

    // MARK: - User management
    func updateCurrentUser(firstName: String, lastName: String, phone: String, completion: @escaping (User?) -> Void) {
        let url = baseURL.appendingPathComponent("/user")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = [
            "firstName": firstName,
            "lastName": lastName,
            "phone": phone
        ]
        request.httpBody = try? JSONEncoder().encode(body)

        let task = session.dataTask(with: request) { data, response, _ in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode)
            else {
                completion(nil)
                return
            }
            let user = try? JSONDecoder.apiDecoder.decode(User.self, from: data)
            completion(user)
        }
        task.resume()
    }

    func getNotifications(completion: @escaping ([NotificationItem]) -> Void) {
        let url = baseURL.appendingPathComponent("/notifications")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request) { data, response, _ in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let notes = try? JSONDecoder.apiDecoder.decode([NotificationItem].self, from: data)
            else {
                completion([])
                return
            }
            completion(notes)
        }
        task.resume()
    }

    func respondToInvitation(notificationId: Int, accept: Bool, completion: @escaping () -> Void) {
        let url = baseURL.appendingPathComponent("/notifications/\(notificationId)/respond")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["accept": accept])

        let task = session.dataTask(with: request) { _, response, _ in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                completion()
                return
            }
            completion()
        }
        task.resume()
    }

    func logout() {
        let url = baseURL.appendingPathComponent("/auth/logout")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let task = session.dataTask(with: request) { _, _, _ in }
        task.resume()
    }
}
