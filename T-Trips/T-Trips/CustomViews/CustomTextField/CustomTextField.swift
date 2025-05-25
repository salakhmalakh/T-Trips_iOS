//
//  CustomTextField.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 12.05.2025.
//

import Foundation
import UIKit

final class CustomTextField: UITextField {
    // MARK: - Properties
    private let textPadding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
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
        font = UIFont.systemFont(ofSize: 16)
        autocorrectionType = .no
        autocapitalizationType = .none
        setupUI()
    }
    
    private func setupUI() {
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
    }

    func setCustomDelegate(_ delegate: UITextFieldDelegate) {
        self.delegate = delegate
        self.strongDelegateReference = delegate
    }
    
    // MARK: - Text Padding Overrides
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}

// MARK: - Constants
private extension CustomTextField {
    enum Constants {
        static let cornerRadius: CGFloat = 12
    }
}
