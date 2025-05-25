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
    private let textPadding = UIEdgeInsets.textPadding
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

    // MARK: - Setup
    private func commonInit() {
        font = UIFont.systemFont(ofSize: CGFloat.fontSize)
        autocorrectionType = .no
        autocapitalizationType = .none
        setupUI()
    }

    private func setupUI() {
        layer.borderWidth = CGFloat.borderWidth
        layer.borderColor = UIColor.borderColor.cgColor
        layer.cornerRadius = CGFloat.cornerRadius
        layer.masksToBounds = true
    }

    // MARK: - Delegate
    func setCustomDelegate(_ delegate: UITextFieldDelegate) {
        self.delegate = delegate
        strongDelegateReference = delegate
    }

    // MARK: - Text Padding Overrides
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }

    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }
}

// MARK: - Constants
private extension UIEdgeInsets {
    static let textPadding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 12
    static let borderWidth: CGFloat = 0.5
    static let fontSize: CGFloat = 16
}

private extension UIColor {
    static let borderColor: UIColor = .lightGray
}
