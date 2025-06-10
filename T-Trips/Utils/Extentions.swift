//
//  Extentions.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 25.05.2025.
//

import Foundation
import UIKit

// MARK: - animation for "press" action
extension UIView {
    func performPressAnimation(pressed: Bool) {
        let transformValue: CGAffineTransform = pressed
            ? CGAffineTransform(scaleX: 0.97, y: 0.97)
            : .identity
        let duration: TimeInterval = pressed ? 0.3 : 0.1
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction],
            animations: { self.transform = transformValue },
            completion: nil
        )
    }
}

// MARK: - JSONDecoder extension
extension JSONDecoder {
    static var apiDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            guard let date = formatter.date(from: dateStr) else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Invalid date: \(dateStr)"
                )
            }
            return date
        }
        return decoder
    }
}

// MARK: - Money formatting
extension Double {
    /// Formats the double as a ruble amount with the sign before the number.
    /// If there are no kopeks, the fractional part is omitted.
    var rubleString: String {
        if truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "₽%.0f", self)
        } else {
            return String(format: "₽%.2f", self)
        }
    }
}

// MARK: - App background color
extension UIColor {
    static let appBackground = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 26/255, green: 26/255, blue: 28/255, alpha: 1)
        } else {
            return UIColor.systemBackground
        }
    }
}

// MARK: - Keyboard dismissal
extension UIViewController {
    /// Hides keyboard when tapping outside of a text field.
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    /// Adjusts view when keyboard appears so it doesn't cover inputs.
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func unregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard
            let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        let inset = frame.height - view.safeAreaInsets.bottom
        additionalSafeAreaInsets.bottom = inset
        view.layoutIfNeeded()
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        additionalSafeAreaInsets.bottom = 0
        view.layoutIfNeeded()
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let expenseAdded = Notification.Name("expenseAdded")
    static let debtCreated = Notification.Name("debtCreated")
    static let tripUpdated = Notification.Name("tripUpdated")
}
