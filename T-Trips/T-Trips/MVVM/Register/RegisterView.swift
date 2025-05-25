//
//  RegisterView.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 22.05.2025.
//

import UIKit
import SnapKit

final class RegisterView: UIView {
    // MARK: - Factories
    private let textFieldFactory = TextFieldFactory()
    private let buttonFactory = ButtonFactory()

    // MARK: - Callbacks
    var onRegister: (() -> Void)?
    var onLogin: (() -> Void)?

    // MARK: - UI Components
    private let shieldImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "shieldT"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public private(set) lazy var fullNameTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: "Имя, Фамилия", state: .name)
        return textFieldFactory.makeTextField(with: model)
    }()

    public private(set) lazy var phoneTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: "Телефон", state: .phoneNumber)
        return textFieldFactory.makeTextField(with: model)
    }()

    public private(set) lazy var passwordTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: "Пароль", state: .password)
        return textFieldFactory.makeTextField(with: model)
    }()

    public private(set) lazy var confirmPasswordTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: "Подтвердить пароль", state: .password)
        return textFieldFactory.makeTextField(with: model)
    }()

    public private(set) lazy var registerButton: CustomButton = {
        let button = CustomButton()
        let model = buttonFactory.makeConfiguration(
            title: "Зарегистрироваться",
            state: .primary,
            isEnabled: false
        ) { [weak self] in self?.onRegister?() }
        button.configure(with: model)
        return button
    }()

    public private(set) lazy var loginButton: CustomButton = {
        let button = CustomButton()
        let model = buttonFactory.makeConfiguration(
            title: "Уже есть аккаунт",
            state: .secondaryBorederless,
            isEnabled: true
        ) { [weak self] in self?.onLogin?() }
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
            fullNameTextField,
            phoneTextField,
            passwordTextField,
            confirmPasswordTextField,
            registerButton,
            loginButton
        ].forEach { addSubview($0) }
    }

    private func setupConstraints() {
        shieldImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(Constants.imageInset)
            make.leading.equalToSuperview().offset(((UIScreen.main.bounds.width) - Constants.imageSize) / 2)
            make.trailing.equalToSuperview().offset(-((UIScreen.main.bounds.width) - Constants.imageSize) / 2)
            make.size.equalTo(Constants.imageSize)
        }

        fullNameTextField.snp.makeConstraints { make in
            make.top.equalTo(shieldImageView.snp.bottom).offset(Constants.imageInset)
            make.leading.trailing.equalToSuperview().inset(Constants.inset)
            make.height.equalTo(Constants.textFieldHeight)
        }
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(fullNameTextField.snp.bottom).offset(Constants.verticalSpacing)
            make.leading.trailing.height.equalTo(fullNameTextField)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(Constants.verticalSpacing)
            make.leading.trailing.height.equalTo(fullNameTextField)
        }
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(Constants.verticalSpacing)
            make.leading.trailing.height.equalTo(fullNameTextField)
        }
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(Constants.varViewsSpacing)
            make.leading.trailing.equalToSuperview().inset(Constants.inset)
            make.height.equalTo(Constants.buttonHeight)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(Constants.verticalSpacing)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Public Binding
    /// Reloads fields values and button accesibility
    func bind(firstName: String, lastName: String, password: String, confirmPassword: String, isRegisterEnabled: Bool) {
        fullNameTextField.text = firstName
        phoneTextField.text = lastName
        passwordTextField.text = password
        confirmPasswordTextField.text = confirmPassword
        registerButton.isEnabled = isRegisterEnabled
    }
}

private extension RegisterView {
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
