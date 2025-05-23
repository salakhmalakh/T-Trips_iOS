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
        let imageView = UIImageView(image: UIImage(named: "shieldT"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    public private(set) lazy var phoneTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: "Телефон", state: .phoneNumber)
        let field = textFieldFactory.makeTextField(with: model)
        field.keyboardType = .phonePad
        return field
    }()

    public private(set) lazy var passwordTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: "Пароль", state: .password)
        return textFieldFactory.makeTextField(with: model)
    }()

    public private(set) lazy var loginButton: CustomButton = {
        let button = CustomButton()
        let model = buttonFactory.makeConfiguration(
            title: "Войти",
            state: .primary,
            isEnabled: false
        ) { [weak self] in self?.onLogin?() }
        button.configure(with: model)
        return button
    }()

    public private(set) lazy var registerButton: CustomButton = {
        let button = CustomButton()
        let model = buttonFactory.makeConfiguration(
            title: "Зарегистрироваться",
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

    // MARK: - Setup UI
    private func setupViews() {
        backgroundColor = .systemBackground
        [
            shieldImageView,
            phoneTextField,
            passwordTextField,
            loginButton,
            registerButton
        ].forEach { addSubview($0) }
    }

    private func setupConstraints() {
        shieldImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(Constants.imageInset)
            make.leading.equalToSuperview().offset(((UIScreen.main.bounds.width) - Constants.imageSize) / 2)
            make.trailing.equalToSuperview().offset(-((UIScreen.main.bounds.width) - Constants.imageSize) / 2)
            make.size.equalTo(Constants.imageSize)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(shieldImageView.snp.bottom).offset(Constants.imageInset)
            make.leading.trailing.equalToSuperview().inset(Constants.inset)
            make.height.equalTo(Constants.textFieldHeight)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(Constants.verticalSpacing)
            make.leading.trailing.height.equalTo(phoneTextField)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(Constants.varViewsSpacing)
            make.leading.trailing.equalToSuperview().inset(Constants.inset)
            make.height.equalTo(Constants.buttonHeight)
        }

        registerButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(Constants.verticalSpacing)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Public Binding
    /// Обновляет значения полей и доступность кнопки
    func bind(phone: String, password: String, isLoginEnabled: Bool) {
        phoneTextField.text = phone
        passwordTextField.text = password
        loginButton.isEnabled = isLoginEnabled
    }
}

private extension AuthView {
    private enum Constants {
        static let imageSize: CGFloat = 100
        static let imageInset: CGFloat = 100
        static let textFieldHeight: CGFloat = 50
        static let buttonHeight: CGFloat = 50
        static let verticalSpacing: CGFloat = 16
        static let varViewsSpacing: CGFloat = 24
        static let screenTopOffset: CGFloat = 40
        static let inset: CGFloat = 20
    }
}
