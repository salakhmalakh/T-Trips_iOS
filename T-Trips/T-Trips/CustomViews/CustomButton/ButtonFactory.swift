//
//  ButtonFactory.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 11.05.2025.
//

import Foundation
import UIKit

enum ButtonFactory {
    static func createButton(with model: ButtonModel) -> CustomButton {
        let button = CustomButton()
        
        button.setTitle(model.title, for: .normal)
        button.isEnabled = model.isEnabled
        
        switch model.state {
        case .primary:
            button.backgroundColor = UIColor(named: "primaryButtonColor")
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 8
        case .secondary:
            button.backgroundColor = UIColor(named: "secondaryButtonColor")
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 8
        case .addition:
            button.backgroundColor = UIColor(named: "primaryButtonColor")
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 8
        }
        
        return button
    }
}
