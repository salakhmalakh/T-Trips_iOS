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
            alpha = isEnabled ? 1.0 : 0.5
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
        alpha = 1.0
        titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .medium)
        addAction(UIAction { [weak self] _ in self?.action?() }, for: .touchUpInside)
    }

    // MARK: - Configuration
    func configure(with model: ButtonModel) {
        setTitle(model.title, for: .normal)
        isEnabled = model.isEnabled
        action = model.action

        switch model.state {
        case .primary:
            backgroundColor = Constants.primaryColor
            setTitleColor(Constants.primaryTextColor, for: .normal)
            layer.cornerRadius = Constants.cornerRadius

        case .secondary:
            backgroundColor = Constants.secondaryColor
            setTitleColor(Constants.secondaryTextColor, for: .normal)
            layer.cornerRadius = Constants.cornerRadius

        case .addition:
            backgroundColor = Constants.primaryColor
            setTitleColor(Constants.primaryTextColor, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: Constants.additionFontSize, weight: .medium)
            layer.cornerRadius = Constants.cornerRadius

        case .secondaryBorederless:
            backgroundColor = Constants.borderlessColor
            setTitleColor(Constants.secondaryTextColor, for: .normal)
            layer.cornerRadius = Constants.cornerRadius
        }
    }
}

// MARK: - Constants
private extension CustomButton {
    enum Constants {
        static let fontSize: CGFloat = 16
        static let additionFontSize: CGFloat = 32
        static let cornerRadius: CGFloat = 12
        static let primaryColor = UIColor(named: "primaryButtonColor")
        static let secondaryColor = UIColor(named: "secondaryButtonColor")
        static let borderlessColor = UIColor.clear
        static let primaryTextColor = UIColor.black
        static let secondaryTextColor = UIColor(named: "secondaryButtonTextColor")
    }
}
