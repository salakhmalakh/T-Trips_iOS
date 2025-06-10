//
//  TextFieldModel.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 12.05.2025.
//

import Foundation

struct TextFieldModel {
    let placeholder: String
    let state: State

    enum State {
        case name
        case title
        case phoneNumber
        case password
        case money
        case picker
    }
}
