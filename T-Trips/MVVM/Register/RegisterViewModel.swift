//
//  RegisterViewModel.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 22.05.2025.
//

import Foundation
import Combine

final class RegisterViewModel {
    // MARK: - Inputs
    @Published var fullName: String = ""
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    // MARK: - Outputs
    @Published private(set) var isRegisterEnabled = false

    // MARK: - Callbacks
    var onRegisterSuccess: (() -> Void)?
    var onRegisterFailure: ((String) -> Void)?
    var onLogin: (() -> Void)?

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init() {
        Publishers.CombineLatest4(
            $fullName,
            $phone,
            $password,
            $confirmPassword
        )
        .map { name, phone, pass, confirm in
            return !name.isEmpty &&
            !phone.isEmpty &&
            pass.count >= .minPasswordLength &&
            confirm.count >= .minPasswordLength
        }
        .receive(on: RunLoop.main)
        .assign(to: \ .isRegisterEnabled, on: self)
        .store(in: &cancellables)
    }

    // MARK: - Actions
    func register() {
        let digits = phone.filter { $0.isNumber }
        guard digits.count == Int.phoneLength else {
            onRegisterFailure?(String.phoneIncomplete)
            return
        }
        guard password.count >= Int.minPasswordLength else {
            onRegisterFailure?(String.passwordTooShort)
            return
        }
        guard password == confirmPassword else {
            onRegisterFailure?(String.passwordMismatch)
            return
        }

        let parts = fullName.split(separator: " ", maxSplits: 1).map(String.init)
        let first = parts.first ?? ""
        let last = parts.count > 1 ? parts[1] : ""
        let phoneNormalized = "+" + digits

        NetworkAPIService.shared.register(
            login: phoneNormalized,
            phone: phoneNormalized,
            name: first,
            surname: last,
            password: password
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.onRegisterSuccess?()
                case .failure(.phoneExists):
                    self?.onRegisterFailure?(String.phoneExists)
                case .failure:
                    self?.onRegisterFailure?(String.registrationFailed)
                }
            }
        }
    }

    func login() {
        onLogin?()
    }
}

// MARK: - Constants
private extension Int {
    static let minPasswordLength = 8
    static let phoneLength = 11
}

private extension String {
    static var passwordTooShort: String { "passwordTooShort".localized }
    static var passwordMismatch: String { "passwordMismatch".localized }
    static var phoneIncomplete: String { "phoneIncomplete".localized }
    static var phoneExists: String { "phoneExists".localized }
    static var registrationFailed: String { "registrationFailed".localized }
}
