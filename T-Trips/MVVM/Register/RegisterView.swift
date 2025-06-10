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

    private let shieldImageView: UIImageView = {
        let view = UIImageView(image: UIImage.tLogo)
        view.contentMode = .scaleAspectFit
        return view
    }()

    public private(set) lazy var fullNameTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.fullName, state: .name)
        return textFieldFactory.makeTextField(with: model)
    }()

    public private(set) lazy var phoneTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.phone, state: .phoneNumber)
        return textFieldFactory.makeTextField(with: model)
    }()

    public private(set) lazy var passwordTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.password, state: .password)
        return textFieldFactory.makeTextField(with: model)
    }()

    public private(set) lazy var confirmPasswordTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.confirmPassword, state: .password)
        return textFieldFactory.makeTextField(with: model)
    }()

    public private(set) lazy var registerButton: CustomButton = {
        let button = CustomButton()
        let model = buttonFactory.makeConfiguration(
            title: String.register,
            state: .primary,
            isEnabled: false
        ) { [weak self] in self?.onRegister?() }
        button.configure(with: model)
        return button
    }()

    public private(set) lazy var loginButton: CustomButton = {
        let button = CustomButton()
        let model = buttonFactory.makeConfiguration(
            title: String.gotAnAccount,
            state: .secondaryBorederless,
            isEnabled: true
        ) { [weak self] in self?.onLogin?() }
        button.configure(with: model)
        return button
    }()

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
        backgroundColor = .appBackground
        [
            shieldImageView, fullNameTextField, phoneTextField, passwordTextField,
            confirmPasswordTextField, registerButton, loginButton
        ]
            .forEach(addSubview)
    }

    private func setupConstraints() {
        shieldImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(CGFloat.registerImageInset)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGFloat.registerImageSize)
        }
        fullNameTextField.snp.makeConstraints { make in
            make.top.equalTo(shieldImageView.snp.bottom).offset(CGFloat.registerImageInset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.registerInset)
            make.height.equalTo(CGFloat.registerTextFieldHeight)
        }
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(fullNameTextField.snp.bottom).offset(CGFloat.registerVerticalSpacing)
            make.leading.trailing.height.equalTo(fullNameTextField)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(CGFloat.registerVerticalSpacing)
            make.leading.trailing.height.equalTo(fullNameTextField)
        }
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(CGFloat.registerVerticalSpacing)
            make.leading.trailing.height.equalTo(fullNameTextField)
        }
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(CGFloat.registerVarViewsSpacing)
            make.leading.trailing.equalToSuperview().inset(CGFloat.registerInset)
            make.height.equalTo(CGFloat.registerButtonHeight)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(CGFloat.registerVerticalSpacing)
            make.centerX.equalToSuperview()
        }
    }
}

private extension CGFloat {
    static let registerImageSize: CGFloat = 100
    static let registerImageInset: CGFloat = 100
    static let registerTextFieldHeight: CGFloat = 50
    static let registerButtonHeight: CGFloat = 50
    static let registerVerticalSpacing: CGFloat = 16
    static let registerVarViewsSpacing: CGFloat = 24
    static let registerInset: CGFloat = 20
}

private extension String {
    static var fullName: String { "fullName".localized }
    static var phone: String { "phone".localized }
    static var password: String { "password".localized }
    static var confirmPassword: String { "confirmPassword".localized }
    static var register: String { "register".localized }
    static var gotAnAccount: String { "gotAnAccount".localized }
}

private extension UIImage {
    static let tLogo = UIImage(named: "shieldT") ?? UIImage()
}
