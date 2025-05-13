//
//  CustomButton.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 11.05.2025.
//

import Foundation

import UIKit

class CustomButton: UIButton {
    weak var actionHandler: ButtonActionHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        actionHandler?.buttonDidTap(self)
    }
}
