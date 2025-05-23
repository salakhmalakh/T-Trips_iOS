//
//  CustomButton.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 11.05.2025.
//

import Foundation
import UIKit

final class CustomButton: UIButton {
    // MARK: - Properties

    private var action: (() -> Void)?

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
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addAction(UIAction { [weak self] _ in self?.action?() }, for: .touchUpInside)
        setupUI()
    }

    func configure(with model: ButtonModel) {
        setTitle(model.title, for: .normal)
        isEnabled = model.isEnabled
        action = model.action

        switch model.state {
        case .primary:
            backgroundColor = Constants.primaryColor
            setTitleColor(.black, for: .normal)
        case .secondary:
            backgroundColor = Constants.secondaryColor
            setTitleColor(UIColor(named: "secondaryButtonTextColor"), for: .normal)
        case .addition:
            backgroundColor = Constants.primaryColor
            setTitleColor(.black, for: .normal)
        case .secondaryBorederless:
            backgroundColor = Constants.secondaryBorderlessColor
            setTitleColor(UIColor(named: "secondaryButtonTextColor"), for: .normal)
        }
    }

    private func setupUI() {
        layer.cornerRadius = Constants.cornerRadius
    }
}

// MARK: - Constants

private extension CustomButton {
    enum Constants {
        static let cornerRadius: CGFloat = 12
        static let primaryColor = UIColor(named: "primaryButtonColor")
        static let secondaryColor = UIColor(named: "secondaryButtonColor")
        static let secondaryBorderlessColor = UIColor.clear
    }
}
