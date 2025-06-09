//
//  RegisterViewController.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 22.05.2025.
//

import UIKit
import Combine

final class RegisterViewController: UIViewController {
    private let registerView = RegisterView()
    private let viewModel = RegisterViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    override func loadView() {
        view = registerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Setup Bindings
    private func setupBindings() {
        viewModel.$isRegisterEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] enabled in
                self?.registerView.registerButton.isEnabled = enabled
            }
            .store(in: &cancellables)

        viewModel.onRegisterSuccess = { [weak self] in
            guard let scene =
                UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let delegate = scene.delegate as? SceneDelegate,
                let window = delegate.window else { return }
            let mainTab = MainTabBarController()
            window.rootViewController = mainTab
            window.makeKeyAndVisible()
            UIView.transition(
                with: window,
                duration: .transitionDuration,
                options: .transitionCrossDissolve,
                animations: nil
            )
        }
        viewModel.onRegisterFailure = { [weak self] message in
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        viewModel.onLogin = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Setup Actions
    private func setupActions() {
        registerView.fullNameTextField.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.fullName = self?.registerView.fullNameTextField.text ?? ""
            },
            for: .editingChanged
        )
        registerView.phoneTextField.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.phone = self?.registerView.phoneTextField.text ?? ""
            },
            for: .editingChanged
        )
        registerView.passwordTextField.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.password = self?.registerView.passwordTextField.text ?? ""
            },
            for: .editingChanged
        )
        registerView.confirmPasswordTextField.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.confirmPassword = self?.registerView.confirmPasswordTextField.text ?? ""
            },
            for: .editingChanged
        )

        registerView.onRegister = { [weak self] in
            self?.viewModel.register()
        }
        registerView.onLogin = { [weak self] in
            self?.viewModel.login()
        }
    }
}

private extension Double {
    static let transitionDuration = 0.2
}
