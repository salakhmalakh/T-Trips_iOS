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
    private let moneyPrefix = "₽"

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
            /// only letters and space are allowed
            let allowed = CharacterSet.letters.union(.whitespaces)
            guard string.rangeOfCharacter(from: allowed.inverted) == nil else { return false }

            let prospective = (currentText as NSString).replacingCharacters(in: range, with: string)
            /// only one space in a row allowed
            if prospective.contains("  ") { return false }

            /// not more than two words is allowed for name
            let words = prospective
                .split(separator: " ", omittingEmptySubsequences: true)
            if words.count > 2 { return false }

            return true

        case .title:
            let allowed = CharacterSet.letters.union(.whitespaces)
            guard string.rangeOfCharacter(from: allowed.inverted) == nil else { return false }
            let prospective = (currentText as NSString).replacingCharacters(in: range, with: string)
            if prospective.contains("  ") { return false }
            return true
            
        case .phoneNumber:
            if currentText.isEmpty, string.rangeOfCharacter(from: .decimalDigits) != nil {
                textField.text = phonePrefix + string
                return false
            }
            /// non-deletable prefix
            if range.location < phonePrefix.count {
                return false
            }
            /// check for prefix presence and length
            let newText = (currentText as NSString)
                .replacingCharacters(in: range, with: string)
            guard newText.hasPrefix(phonePrefix) else { return false }
            let suffix = newText.dropFirst(phonePrefix.count)
            return suffix.allSatisfy { $0.isNumber } && newText.count <= 12
            
        case .picker:
            if string.isEmpty {
                return false
            }
            return true
            
        default:
            return true
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        /// remove formatting when the phone is being edited
        if state == .phoneNumber, let current = textField.text {
            let digits = current.filter { $0.isNumber }
            textField.text = phonePrefix + digits.dropFirst()
        }
        /// remove formatting when the money is being edited
        if state == .money, let current = textField.text {
            let digits = current.filter { $0.isNumber }
            textField.text = digits
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        switch state {
        case .name:
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            let capitalized = trimmed.capitalized
            let parts = capitalized.split(
                separator: " ",
                maxSplits: 1,
                omittingEmptySubsequences: true)
                .map(String.init)
            let first = parts.first ?? ""
            let last  = parts.count > 1 ? parts[1] : ""
            textField.text = [first, last]
                .filter { !$0.isEmpty }
                .joined(separator: " ")

        case .title:
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            let capitalized = trimmed.capitalized
            let singleSpaced = capitalized.replacingOccurrences(of: "  ", with: " ")
            textField.text = singleSpaced

        case .phoneNumber:
            /// applies formatting after leaving the TF
            let digits = text.filter { $0.isNumber }
            textField.text = formatPhoneNumber(digits)

        case .money:
            /// applies formatting after leaving the TF
            let digits = text.filter { $0.isNumber }
            textField.text = formatMoney(digits)
            
        default:
            break
        }
    }

    // MARK: - Helpers

    private func formatPhoneNumber(_ digits: String) -> String {
        /// formatting: +7 (XXX) XXX-XX-XX
        var result = ""
        let chars = Array(digits)
        for (idx, aChar) in chars.enumerated() {
            if idx == 0 {
                result += "+"
            }
            if idx == 1 {
                result += " ("
            }
            if idx == 4 {
                result += ") "
            }
            if idx == 7 || idx == 9 {
                result += "-"
            }
            result.append(aChar)
        }
        return result
    }
    private func formatMoney(_ digits: String) -> String {
        /// formatting: ₽99.99
        var result = ""
        let chars = Array(digits)
        for (idx, aChar) in chars.enumerated() {
            if idx == 0 {
                result += "₽"
            }
            result.append(aChar)
        }
        return result
    }
}
