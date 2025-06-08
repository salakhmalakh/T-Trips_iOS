//
//  ButtonModel.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 11.05.2025.
//

import Foundation

struct ButtonModel {
    let title: String
    let state: State
    let isEnabled: Bool
    let action: (() -> Void)?

    enum State {
        case primary
        case secondary
        case secondaryBorederless
        case addition
    }
}
