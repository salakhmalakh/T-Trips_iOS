//
//  ButtonFactory.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 11.05.2025.
//

import Foundation

protocol ButtonFactoryProtocol {
    func makeConfiguration(
        title: String,
        state: ButtonModel.State,
        isEnabled: Bool,
        action: (() -> Void)?
    ) -> ButtonModel
}

final class ButtonFactory: ButtonFactoryProtocol {
    func makeConfiguration(
        title: String,
        state: ButtonModel.State,
        isEnabled: Bool,
        action: (() -> Void)?
    ) -> ButtonModel {
        return ButtonModel(title: title, state: state, isEnabled: isEnabled, action: action)
    }
}
