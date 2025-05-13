//
//  TextFieldModel.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 12.05.2025.
//

import Foundation

struct TextFieldModel {
    let placeholder: String
    let state: TextFieldState
}

enum TextFieldState {
    case name
    case phoneNumber
    case password
}
