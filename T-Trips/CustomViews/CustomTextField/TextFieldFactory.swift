//
//  TextFieldFactory.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 12.05.2025.
//

import Foundation
import UIKit

protocol TextFieldFactoryProtocol {
    func makeTextField(with model: TextFieldModel) -> CustomTextField
}

final class TextFieldFactory: TextFieldFactoryProtocol {
    func makeTextField(with model: TextFieldModel) -> CustomTextField {
        let textField = CustomTextField()
        textField.placeholder = model.placeholder

        switch model.state {
        case .name:
            textField.keyboardType = .default
        case .phoneNumber:
            textField.keyboardType = .numberPad
       case .password:
            textField.keyboardType = .default
            textField.textContentType = .oneTimeCode
            textField.passwordRules = nil
            textField.isSecureTextEntry = true
            // Disable password suggestions
            textField.inputAssistantItem.leadingBarButtonGroups = []
            textField.inputAssistantItem.trailingBarButtonGroups = []
        case .money:
            textField.keyboardType = .numberPad
        case .picker:
            textField.keyboardType = .default
        }

        let customDelegate = CustomTextFieldDelegate(state: model.state)
        textField.setCustomDelegate(customDelegate)

        return textField
    }
}
