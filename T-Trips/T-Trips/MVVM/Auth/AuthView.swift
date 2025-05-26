//
//  AuthView.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 01.05.2025.
//

import UIKit
import SnapKit

final class AuthView: UIView {
    // MARK: - Factories
    private let textFieldFactory = TextFieldFactory()
    private let buttonFactory = ButtonFactory()

    // MARK: - Callbacks
    var onLogin: (() -> Void)?
    var onRegister: (() -> Void)?

    // MARK: - UI Components
    private let shieldImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.tLogo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    public private(set) lazy var phoneTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.phone, state: .phoneNumber)
        let field = textFieldFactory.makeTextField(with: model)
        field.keyboardType = .phonePad
        return field
    }()

    public private(set) lazy var passwordTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.password, state: .password)
        return textFieldFactory.makeTextField(with: model)
    }()

    public private(set) lazy var loginButton: CustomButton = {
        let button = CustomButton()
        let model = buttonFactory.makeConfiguration(
            title: String.login,
            state: .primary,
            isEnabled: false
        ) { [weak self] in self?.onLogin?() }
        button.configure(with: model)
        return button
    }()

    public private(set) lazy var registerButton: CustomButton = {
        let button = CustomButton()
        let model = buttonFactory.makeConfiguration(
            title: String.register,
            state: .secondaryBorederless,
            isEnabled: true
        ) { [weak self] in self?.onRegister?() }
        button.configure(with: model)
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundColor = .systemBackground
        [shieldImageView, phoneTextField, passwordTextField, loginButton, registerButton]
            .forEach(addSubview)
    }

    private func setupConstraints() {
        shieldImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(CGFloat.authImageInset)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGFloat.authImageSize)
        }
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(shieldImageView.snp.bottom).offset(CGFloat.authImageInset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.authInset)
            make.height.equalTo(CGFloat.authTextFieldHeight)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(CGFloat.authVerticalSpacing)
            make.leading.trailing.height.equalTo(phoneTextField)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(CGFloat.authVarViewsSpacing)
            make.leading.trailing.equalToSuperview().inset(CGFloat.authInset)
            make.height.equalTo(CGFloat.authButtonHeight)
        }
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(CGFloat.authVerticalSpacing)
            make.centerX.equalToSuperview()
        }
    }
}

private extension CGFloat {
    static let authImageSize: CGFloat = 100
    static let authImageInset: CGFloat = 100
    static let authTextFieldHeight: CGFloat = 50
    static let authButtonHeight: CGFloat = 50
    static let authVerticalSpacing: CGFloat = 16
    static let authVarViewsSpacing: CGFloat = 24
    static let authInset: CGFloat = 20
}

private extension String {
    static let phone: String = "Телефон"
    static let password: String = "Пароль"
    static let login: String = "Войти"
    static let register: String = "Зарегистрироваться"
}

private extension UIImage {
    static let tLogo = UIImage(named: "shieldT") ?? UIImage()
}
