// swiftlint:disable type_body_length
import Foundation

/// Service for communicating with the real backend.
/// Currently only includes a couple of implemented methods.
final class NetworkAPIService {
    static let shared = NetworkAPIService()

    /// Base URL for the backend API.
    private let baseURL = URL(string: "http://82.202.136.132:8082")!
    private let session: URLSession
    private(set) var currentUser: User?
    private(set) var tokenPair: JwtTokenPair?
    /// Cached list of users retrieved from the backend
    private(set) var usersCache: [User] = []

    init(session: URLSession = .shared) {
        self.session = session
    }

    private func addAuthHeader(_ request: inout URLRequest) {
        if let token = tokenPair?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }

    private func logError(request: URLRequest, response: URLResponse?, data: Data?, error: Error?) {
        var parts: [String] = []
        if let url = request.url { parts.append("URL: \(url.absoluteString)") }
        if let httpResponse = response as? HTTPURLResponse {
            parts.append("status: \(httpResponse.statusCode)")
        }
        if let error = error { parts.append("error: \(error.localizedDescription)") }
        if let data = data, !data.isEmpty, let body = String(data: data, encoding: .utf8) {
            parts.append("body: \(body)")
        }
        if !parts.isEmpty { print("[NetworkAPIService] " + parts.joined(separator: " | ")) }
    }

    // MARK: - Auth
    func authenticate(phone: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = baseURL.appendingPathComponent("/api/v1/auth/login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(phone: phone, password: password)
        request.httpBody = try? JSONEncoder().encode(body)

        let task = session.dataTask(with: request) { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode)
            else {
                self.logError(request: request, response: response, data: data, error: error)
                completion(false)
                return
            }
            if let data = data,
               let pair = try? JSONDecoder.apiDecoder.decode(JwtTokenPair.self, from: data) {
                self.tokenPair = pair
            } else {
                self.logError(request: request, response: response, data: data, error: error)
            }
            completion(true)
        }
        task.resume()
    }

    enum RegisterError: Error {
        case phoneExists
        case unknown
    }

    func register(login: String, phone: String, name: String, surname: String, password: String, completion: @escaping (Result<Void, RegisterError>) -> Void) {
        let url = baseURL.appendingPathComponent("/api/v1/users")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = RegisterRequest(login: login, phone: phone, password: password, name: name, surname: surname)
        request.httpBody = try? JSONEncoder().encode(body)

        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                self.logError(request: request, response: response, data: data, error: error)
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
                self.logError(request: request, response: response, data: data, error: error)
                completion(.failure(.unknown))
            }
        }
        task.resume()
    }

    // MARK: - Trips
    func getUserTrips(status: Trip.Status, completion: @escaping ([Trip]) -> Void) {
        var components = URLComponents(url: baseURL.appendingPathComponent("/api/v1/trips"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "status", value: status.rawValue)]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        addAuthHeader(&request)

        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let trips = try? JSONDecoder.apiDecoder.decode([Trip].self, from: data)
            else {
                self.logError(request: request, response: response, data: data, error: error)
                completion([])
                return
            }
            completion(trips)
        }
        task.resume()
    }

    func getTrip(id: Int64, completion: @escaping (Trip?) -> Void) {
        let url = baseURL.appendingPathComponent("/api/v1/trips/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        addAuthHeader(&request)

        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let trip = try? JSONDecoder.apiDecoder.decode(Trip.self, from: data)
            else {
                self.logError(request: request, response: response, data: data, error: error)
                completion(nil)
                return
            }
            completion(trip)
        }
        task.resume()
    }

    func createTrip(_ dto: TripDtoForCreate, completion: @escaping (Trip?) -> Void) {
        let url = baseURL.appendingPathComponent("/api/v1/trips")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        addAuthHeader(&request)
        let payload: [String: Any] = [
            "title": dto.title,
            "startDate": ISO8601DateFormatter().string(from: dto.startDate),
            "endDate": ISO8601DateFormatter().string(from: dto.endDate),
            "status": dto.status.rawValue,
            "budget": dto.budget,
            "description": dto.description as Any,
            "participantIds": dto.participantIds
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])

        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let trip = try? JSONDecoder.apiDecoder.decode(Trip.self, from: data)
            else {
                self.logError(request: request, response: response, data: data, error: error)
                completion(nil)
                return
            }
            completion(trip)
        }
        task.resume()
    }

    func updateTrip(_ trip: Trip, completion: @escaping (Trip?) -> Void) {
        let url = baseURL.appendingPathComponent("/api/v1/trips/\(trip.id)")
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        addAuthHeader(&request)
        request.httpBody = try? JSONEncoder().encode(trip)

        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let updated = try? JSONDecoder.apiDecoder.decode(Trip.self, from: data)
            else {
                self.logError(request: request, response: response, data: data, error: error)
                completion(nil)
                return
            }
            completion(updated)
        }
        task.resume()
    }

    func leaveTrip(tripId: Int64, userId: Int64, completion: @escaping (Trip?) -> Void) {
        let url = baseURL.appendingPathComponent("/api/v1/trips/\(tripId)/leave")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        addAuthHeader(&request)
        request.httpBody = try? JSONEncoder().encode(["userId": userId])

        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode)
            else {
                self.logError(request: request, response: response, data: data, error: error)
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
        let url = baseURL.appendingPathComponent("/api/v1/trips/\(tripId)/expenses")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        addAuthHeader(&request)

        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let expenses = try? JSONDecoder.apiDecoder.decode([Expense].self, from: data)
            else {
                self.logError(request: request, response: response, data: data, error: error)
                completion([])
                return
            }
            completion(expenses)
        }
        task.resume()
    }

    func createExpense(tripId: Int64, dto: ExpenseDtoForCreate, ownerId: Int64, completion: @escaping (Expense?) -> Void) {
        let url = baseURL.appendingPathComponent("/api/v1/trips/\(tripId)/expenses")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        addAuthHeader(&request)

        request.httpBody = try? JSONEncoder().encode(dto)

        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let expense = try? JSONDecoder.apiDecoder.decode(Expense.self, from: data)
            else {
                self.logError(request: request, response: response, data: data, error: error)
                completion(nil)
                return
            }
            completion(expense)
        }
        task.resume()
    }

    func deleteExpense(tripId: Int64, id: Int64, completion: @escaping () -> Void) {
        let url = baseURL.appendingPathComponent("/api/v1/trips/\(tripId)/expenses/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        addAuthHeader(&request)

        let task = session.dataTask(with: request) { _, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                self.logError(request: request, response: response, data: nil, error: error)
                completion()
                return
            }
            completion()
        }
        task.resume()
    }

    // MARK: - Debts
    func getDebts(tripId: Int64, userId: Int64?, completion: @escaping ([Debt]) -> Void) {
        var components = URLComponents(url: baseURL.appendingPathComponent("/api/v1/debts"), resolvingAgainstBaseURL: false)!
        var items = [URLQueryItem(name: "tripId", value: String(tripId))]
        if let uid = userId {
            items.append(URLQueryItem(name: "userId", value: String(uid)))
        }
        components.queryItems = items
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        addAuthHeader(&request)

        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let debts = try? JSONDecoder.apiDecoder.decode([Debt].self, from: data)
            else {
                self.logError(request: request, response: response, data: data, error: error)
                completion([])
                return
            }
            completion(debts)
        }
        task.resume()
    }

    func payDebt(id: String, completion: @escaping () -> Void) {
        let url = baseURL.appendingPathComponent("/api/v1/debts/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        addAuthHeader(&request)

        let task = session.dataTask(with: request) { _, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                self.logError(request: request, response: response, data: nil, error: error)
                completion()
                return
            }
            completion()
        }
        task.resume()
    }

    // MARK: - Participants
    /// Searches user by phone using the `/api/v1/users` endpoint.
    /// - Parameters:
    ///   - phone: Full phone number including the leading `+`.
    ///   - completion: Callback with the found user or `nil`.
    func findParticipant(phone: String, completion: @escaping (User?) -> Void) {
        getAllUsers { users in
            let user = users.first { $0.phone == phone }
            completion(user)
        }
    }

    /// Fetches all registered users. Results are cached for subsequent calls.
    func getAllUsers(completion: @escaping ([User]) -> Void) {
        if !usersCache.isEmpty {
            completion(usersCache)
            return
        }
        let url = baseURL.appendingPathComponent("/api/v1/users")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        addAuthHeader(&request)

        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let users = try? JSONDecoder.apiDecoder.decode([User].self, from: data)
            else {
                self.logError(request: request, response: response, data: data, error: error)
                completion([])
                return
            }
            self.usersCache = users
            completion(users)
        }
        task.resume()
    }

    /// Searches users on the backend by a query string.
    /// - Parameters:
    ///   - query: Partial name or phone to search for.
    ///   - completion: Callback with found users or an empty array on failure.
    func searchUsers(query: String, completion: @escaping ([User]) -> Void) {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("/api/v1/users"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [URLQueryItem(name: "search", value: query)]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        addAuthHeader(&request)

        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let users = try? JSONDecoder.apiDecoder.decode([User].self, from: data)
            else {
                self.logError(request: request, response: response, data: data, error: error)
                completion([])
                return
            }
            completion(users)
        }
        task.resume()
    }

    // MARK: - User management
    func updateCurrentUser(firstName: String, lastName: String, phone: String, completion: @escaping (User?) -> Void) {
        guard let id = currentUser?.id else {
            completion(nil)
            return
        }
        let url = baseURL.appendingPathComponent("/api/v1/users/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        addAuthHeader(&request)
        let body: [String: String] = [
            "name": firstName,
            "surname": lastName,
            "phone": phone
        ]
        request.httpBody = try? JSONEncoder().encode(body)

        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode)
            else {
                self.logError(request: request, response: response, data: data, error: error)
                completion(nil)
                return
            }
            let user = try? JSONDecoder.apiDecoder.decode(User.self, from: data)
            completion(user)
        }
        task.resume()
    }

    func getNotifications(completion: @escaping ([NotificationItem]) -> Void) {
        let url = baseURL.appendingPathComponent("/api/v1/notifications")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        addAuthHeader(&request)

        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let notes = try? JSONDecoder.apiDecoder.decode([NotificationItem].self, from: data)
            else {
                self.logError(request: request, response: response, data: data, error: error)
                completion([])
                return
            }
            completion(notes)
        }
        task.resume()
    }

    func respondToInvitation(notificationId: Int, accept: Bool, completion: @escaping () -> Void) {
        let url = baseURL.appendingPathComponent("/api/v1/notifications/\(notificationId)/respond")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        addAuthHeader(&request)
        request.httpBody = try? JSONEncoder().encode(["accept": accept])

        let task = session.dataTask(with: request) { _, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                self.logError(request: request, response: response, data: nil, error: error)
                completion()
                return
            }
            completion()
        }
        task.resume()
    }

    func logout() {
        let url = baseURL.appendingPathComponent("/api/v1/auth/logout")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        addAuthHeader(&request)

        let task = session.dataTask(with: request) { _, response, error in
            if let httpResponse = response as? HTTPURLResponse,
               !(200..<300).contains(httpResponse.statusCode) || error != nil {
                self.logError(request: request, response: response, data: nil, error: error)
            }
        }
        task.resume()
    }
}
// swiftlint:enable type_body_length
