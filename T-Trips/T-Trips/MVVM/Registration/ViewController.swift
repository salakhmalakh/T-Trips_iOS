//
//  ViewController.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 01.05.2025.
//

import UIKit

class ViewController: UIViewController, ButtonActionHandler {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
        setupTextFields()
    }
    
    private func setupButtons() {
        let primaryModel = ButtonModel(title: "Primary Button", state: .primary, isEnabled: true)
        let secondaryModel = ButtonModel(title: "Secondary Button", state: .secondary, isEnabled: true)
        let additionModel = ButtonModel(title: "+", state: .addition, isEnabled: true)

        let primaryButton = ButtonFactory.createButton(with: primaryModel)
        let secondaryButton = ButtonFactory.createButton(with: secondaryModel)
        let additionButton = ButtonFactory.createButton(with: additionModel)

        primaryButton.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 50)
        secondaryButton.frame = CGRect(x: 20, y: 170, width: view.frame.width - 40, height: 50)
        additionButton.frame = CGRect(x: 20, y: 240, width: 50, height: 50)

        primaryButton.actionHandler = self
        secondaryButton.actionHandler = self
        additionButton.actionHandler = self

        view.addSubview(primaryButton)
        view.addSubview(secondaryButton)
        view.addSubview(additionButton)
    }

    private func setupTextFields() {
        let nameFieldModel = TextFieldModel(placeholder: "Name", state: .name)
        let phoneFieldModel = TextFieldModel(placeholder: "Phone Number", state: .phoneNumber)
        let passwordFieldModel = TextFieldModel(placeholder: "Password", state: .password)

        let nameTextField = TextFieldFactory.createTextField(with: nameFieldModel)
        let phoneTextField = TextFieldFactory.createTextField(with: phoneFieldModel)
        let passwordTextField = TextFieldFactory.createTextField(with: passwordFieldModel)

        nameTextField.frame = CGRect(x: 20, y: 320, width: view.frame.width - 40, height: 40)
        phoneTextField.frame = CGRect(x: 20, y: 370, width: view.frame.width - 40, height: 40)
        passwordTextField.frame = CGRect(x: 20, y: 420, width: view.frame.width - 40, height: 40)

        view.addSubview(nameTextField)
        view.addSubview(phoneTextField)
        view.addSubview(passwordTextField)
    }

    func buttonDidTap(_ button: CustomButton) {
        print("Button tapped: \(button.titleLabel?.text ?? "")")

        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = .identity
            }
        })
    }
}
