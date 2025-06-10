import Foundation

/// Service for communicating with the real backend.
/// Currently only includes a couple of implemented methods.
final class NetworkAPIService {
    static let shared = NetworkAPIService()

    /// Base URL for the backend API.
    private let baseURL = URL(string: "http://82.202.136.132:8082")!
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Auth
    func authenticate(phone: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = baseURL.appendingPathComponent("/auth/login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = [
            "phone": phone,
            "password": password
        ]
        request.httpBody = try? JSONEncoder().encode(body)

        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                completion(false)
                return
            }
            completion(true)
        }
        task.resume()
    }

    func register(phone: String, firstName: String, lastName: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = baseURL.appendingPathComponent("/auth/register")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = [
            "phone": phone,
            "firstName": firstName,
            "lastName": lastName,
            "password": password
        ]
        request.httpBody = try? JSONEncoder().encode(body)

        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                completion(false)
                return
            }
            completion(true)
        }
        task.resume()
    }

    // MARK: - TODO: Implement other methods using real API
}
