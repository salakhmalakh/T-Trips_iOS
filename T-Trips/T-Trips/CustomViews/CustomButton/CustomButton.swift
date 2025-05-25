//
//  CustomButton.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 11.05.2025.
//

import Foundation
import UIKit

final class CustomButton: UIButton {
    // MARK: - Press Animation
    override var isHighlighted: Bool {
        didSet { performPressAnimation(pressed: isHighlighted) }
    }

    // MARK: - Properties
    private var action: (() -> Void)?
    public var labelColor: UIColor? {
        didSet { setTitleColor(labelColor, for: .normal) }
    }
    
    // MARK: – Override enabled state
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? CGFloat.defaultAlpha : CGFloat.translucentAlpha
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        alpha = CGFloat.defaultAlpha
        titleLabel?.font = UIFont.systemFont(ofSize: CGFloat.fontSize, weight: .medium)
        addAction(UIAction { [weak self] _ in self?.action?() }, for: .touchUpInside)
    }

    // MARK: - Configuration
    func configure(with model: ButtonModel) {
        setTitle(model.title, for: .normal)
        isEnabled = model.isEnabled
        action = model.action

        switch model.state {
        case .primary:
            backgroundColor = UIColor.primaryColor
            setTitleColor(UIColor.primaryTextColor, for: .normal)
            layer.cornerRadius = CGFloat.cornerRadius

        case .secondary:
            backgroundColor = UIColor.secondaryColor
            setTitleColor(UIColor.secondaryTextColor, for: .normal)
            layer.cornerRadius = CGFloat.cornerRadius

        case .addition:
            backgroundColor = UIColor.primaryColor
            setTitleColor(UIColor.primaryTextColor, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: CGFloat.additionFontSize, weight: .medium)
            layer.cornerRadius = CGFloat.cornerRadius

        case .secondaryBorederless:
            backgroundColor = UIColor.borderlessColor
            setTitleColor(UIColor.secondaryTextColor, for: .normal)
            layer.cornerRadius = CGFloat.cornerRadius
        }
    }
}

// MARK: - Constants
private extension CGFloat {
    static let fontSize: CGFloat = 16
    static let defaultAlpha: CGFloat = 1.0
    static let translucentAlpha: CGFloat = 0.5
    static let additionFontSize: CGFloat = 32
    static let cornerRadius: CGFloat = 12
}

private extension UIColor {
    static let primaryColor = UIColor(named: "primaryButtonColor")
    static let secondaryColor = UIColor(named: "secondaryButtonColor")
    static let borderlessColor = UIColor.clear
    static let primaryTextColor = UIColor.black
    static let secondaryTextColor = UIColor(named: "secondaryButtonTextColor")
}
