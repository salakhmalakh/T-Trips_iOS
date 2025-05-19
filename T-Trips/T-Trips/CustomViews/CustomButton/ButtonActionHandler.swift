//
//  ButtonActionHandler.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 11.05.2025.
//

import Foundation

protocol ButtonActionHandler: AnyObject {
    func buttonDidTap(_ button: CustomButton)
}
