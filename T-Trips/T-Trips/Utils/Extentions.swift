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
