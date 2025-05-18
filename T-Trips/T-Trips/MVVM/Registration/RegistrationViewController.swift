//
//  ViewController.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 01.05.2025.
//

import UIKit
import SnapKit

final class RegistrationViewController: UIViewController {
    // MARK: - Factories

    private let buttonFactory = ButtonFactory()
    private let textFieldFactory = TextFieldFactory()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        setupTextFields()
        setupButtons()
    }

    private func setupTextFields() {
        let models: [TextFieldModel] = [
            .init(placeholder: "Name", state: .name),
            .init(placeholder: "Phone Number", state: .phoneNumber),
            .init(placeholder: "Password", state: .password)
        ]

        var previousView: UIView?

        for model in models {
            let field = textFieldFactory.makeTextField(with: model)
            view.addSubview(field)

            field.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(40)
                if let previous = previousView {
                    make.top.equalTo(previous.snp.bottom).offset(16)
                } else {
                    make.top.equalToSuperview().offset(100)
                }
            }

            previousView = field
        }
    }

    private func setupButtons() {
        let models: [ButtonModel] = [
            buttonFactory.makeConfiguration(
                title: "Primary",
                state: .primary,
                isEnabled: true
            ) {
                print("Primary tapped")
            },
            buttonFactory.makeConfiguration(
                title: "Secondary",
                state: .secondary,
                isEnabled: true
            ) {
                print("Secondary tapped")
            },
            buttonFactory.makeConfiguration(
                title: "+",
                state: .addition,
                isEnabled: true
            ) {
                print("Addition tapped")
            }
        ]

        var previousView: UIView? = view.subviews.last

        for model in models {
            let button = CustomButton()
            button.configure(with: model)
            view.addSubview(button)

            button.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(50)
                if let previous = previousView {
                    make.top.equalTo(previous.snp.bottom).offset(24)
                }
            }

            previousView = button
        }
    }
}
