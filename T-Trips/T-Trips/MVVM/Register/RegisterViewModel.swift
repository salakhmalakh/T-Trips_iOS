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
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    // MARK: - Outputs
    @Published private(set) var isRegisterEnabled = false

    // MARK: - Callbacks
    var onRegisterSuccess: (() -> Void)?
    var onLogin: (() -> Void)?

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init() {
        Publishers.CombineLatest4(
            $firstName,
            $lastName,
            $password,
            $confirmPassword
        )
        .map { first, last, pass, confirm in
            return !first.isEmpty && !last.isEmpty && pass.count >= 8 && pass == confirm
        }
        .receive(on: RunLoop.main)
        .assign(to: \ .isRegisterEnabled, on: self)
        .store(in: &cancellables)
    }

    // MARK: - Actions
    func register() {
        // TODO: API call
        onRegisterSuccess?()
    }

    func login() {
        onLogin?()
    }
}
