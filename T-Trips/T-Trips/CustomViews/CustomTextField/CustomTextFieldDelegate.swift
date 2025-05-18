//
//  CustomTextFieldDelegate.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 12.05.2025.
//

import Foundation
import UIKit

final class CustomTextFieldDelegate: NSObject, UITextFieldDelegate {
    // MARK: - Properties

    private let state: TextFieldModel.State
    private let phonePrefix = "+7"

    // MARK: - Init

    init(state: TextFieldModel.State) {
        self.state = state
    }

    // MARK: - UITextFieldDelegate

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let currentText = textField.text else { return true }

        switch state {
        case .name:
            let allowed = CharacterSet.letters.union(.whitespaces)
            return string.rangeOfCharacter(from: allowed.inverted) == nil

        case .password:
            return true

        case .phoneNumber:
            if currentText.isEmpty && string.rangeOfCharacter(from: .decimalDigits) != nil {
                textField.text = phonePrefix + string
                return false
            }

            if range.location < phonePrefix.count {
                return false
            }

            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            guard newText.hasPrefix(phonePrefix) else { return false }
            let suffix = newText.dropFirst(phonePrefix.count)

            return suffix.allSatisfy { $0.isNumber } && newText.count <= 12
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if state == .phoneNumber, (textField.text ?? "").isEmpty {
            textField.text = phonePrefix
        }
    }
}
