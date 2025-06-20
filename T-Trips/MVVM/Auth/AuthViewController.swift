//
//  AuthViewController.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 22.05.2025.
//

import UIKit
import Combine

final class AuthViewController: UIViewController {
    private let authView = AuthView()
    private let viewModel = AuthViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    override func loadView() {
        view = authView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = .authTitle
        setupBindings()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Setup
    private func setupBindings() {
        // ViewModel -> View
        viewModel.$isLoginEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] enabled in
                self?.authView.loginButton.isEnabled = enabled
            }
            .store(in: &cancellables)

        // Navigation
        viewModel.onLoginSuccess = {
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

        viewModel.onLoginFailure = { [weak self] in
            let alert = UIAlertController(
                title: nil,
                message: String.invalidCreds,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }

        viewModel.onRegister = { [weak self] in
            guard let self = self else { return }
            let registerVC = RegisterViewController()
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
    }

    private func setupActions() {
        // TextField -> ViewModel 
        authView.phoneTextField.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.phone = self?.authView.phoneTextField.text ?? ""
            },
            for: .editingChanged
        )
        authView.passwordTextField.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.password = self?.authView.passwordTextField.text ?? ""
            },
            for: .editingChanged
        )

        // Buttons callbacks
        authView.onLogin = { [weak self] in
            self?.viewModel.login()
        }
        authView.onRegister = { [weak self] in
            self?.viewModel.register()
        }
    }
}

// MARK: - Constants
private extension String {
    static var authTitle: String { "login".localized }
    static var invalidCreds: String { "invalidCreds".localized }
}

private extension Double {
    static let transitionDuration = 0.2
}
