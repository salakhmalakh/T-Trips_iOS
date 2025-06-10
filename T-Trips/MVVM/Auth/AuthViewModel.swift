//
//  AuthViewModel.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 22.05.2025.
//

import Foundation
import Combine

final class AuthViewModel {
    // MARK: - Inputs
    @Published var phone: String = ""
    @Published var password: String = ""

    // MARK: - Outputs
    @Published private(set) var isLoginEnabled = false

    // MARK: - Callbacks
    var onLoginSuccess: (() -> Void)?
    var onRegister: (() -> Void)?
    var onLoginFailure: (() -> Void)?

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init() {
        // Enable the button when the phone tf is not blank and the password is not shorter than 8 symblos
        Publishers.CombineLatest($phone, $password)
            .map { phone, password in
                return !phone.isEmpty && password.count >= .minPasswordLength
            }
            .receive(on: RunLoop.main)
            .assign(to: \ .isLoginEnabled, on: self)
            .store(in: &cancellables)
    }

    // MARK: - Actions
    func login() {
        // Normalize phone number to remove formatting
        let digits = phone.filter { $0.isNumber }
        let normalized = "+" + digits
        NetworkAPIService.shared.authenticate(phone: normalized, password: password) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.onLoginSuccess?()
                } else {
                    self?.onLoginFailure?()
                }
            }
        }
    }

    func register() {
        onRegister?()
    }
}

// MARK: - Constants
private extension Int {
    static let minPasswordLength = 8
}
