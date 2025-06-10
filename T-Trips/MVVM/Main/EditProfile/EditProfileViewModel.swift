import Foundation
import Combine

final class EditProfileViewModel {
    @Published var firstName: String
    @Published var lastName: String
    @Published var phone: String
    @Published private(set) var isSaveEnabled = false

    var onSaved: (() -> Void)?

    private var cancellables = Set<AnyCancellable>()

    init(user: User) {
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.phone = user.phone

        Publishers.CombineLatest3($firstName, $lastName, $phone)
            .map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty }
            .receive(on: RunLoop.main)
            .assign(to: \ .isSaveEnabled, on: self)
            .store(in: &cancellables)
    }

    func save() {
        NetworkAPIService.shared.updateCurrentUser(firstName: firstName, lastName: lastName, phone: phone) { [weak self] user in
            DispatchQueue.main.async {
                if user != nil { self?.onSaved?() }
            }
        }
    }
}
