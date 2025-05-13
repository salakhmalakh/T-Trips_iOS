//
//  ButtonModel.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 11.05.2025.
//

import Foundation

struct ButtonModel {
    let title: String
    let state: ButtonState
    let isEnabled: Bool
}

enum ButtonState {
    case primary
    case secondary
    case addition
}
