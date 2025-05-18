//
//  CustomTextField.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 12.05.2025.
//

import Foundation
import UIKit

final class CustomTextField: UITextField {    
    // MARK: - Private

    private var strongDelegateReference: UITextFieldDelegate?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Methods

    private func commonInit() {
        borderStyle = .roundedRect
        font = UIFont.systemFont(ofSize: 16)
        autocorrectionType = .no
        autocapitalizationType = .none
    }

    func setCustomDelegate(_ delegate: UITextFieldDelegate) {
        self.delegate = delegate
        self.strongDelegateReference = delegate
    }
}
