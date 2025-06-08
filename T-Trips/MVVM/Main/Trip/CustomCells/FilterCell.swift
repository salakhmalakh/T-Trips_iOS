//
//  FilterCell.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 24.05.2025.
//

import UIKit
import SnapKit

final class FilterCell: UICollectionViewCell {
    static let reuseId = String.reuseId
    private let titleLabel = UILabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = .cornerRadius
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.shadowColor
        layer.shadowOpacity = .shadowOpacity
        layer.shadowOffset = .shadowOffset
        layer.shadowRadius = .shadowRadius
        layer.masksToBounds = false

        contentView.addSubview(titleLabel)

        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: .fontSize, weight: .medium)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(CGFloat.textInset)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(
            roundedRect: contentView.frame,
            cornerRadius: contentView.layer.cornerRadius
        ).cgPath
    }

    // MARK: - Configure
    func configure(title: String, selected: Bool) {
        titleLabel.text = title
        let textColor: UIColor = selected ? UIColor.selectedTextColor : UIColor.defaultTextColor
        titleLabel.textColor = textColor
        contentView.layer.borderWidth = .borderWidth
        contentView.layer.borderColor = (selected ? UIColor.selectedBorderColor : UIColor.defaultBorderColor)

            .cgColor
    }
}

// MARK: - Constants
private extension CGFloat {
    static let cornerRadius: CGFloat = 12
    static let shadowRadius: CGFloat = 4
    static let textInset: CGFloat = 8
    static let fontSize: CGFloat = 14
    static let borderWidth: CGFloat = 1
}

private extension Float {
    static let shadowOpacity: Float = 0.1
}

private extension String {
    static let reuseId = "FilterCell"
}

private extension UIColor {
    static let shadowColor = UIColor.black.cgColor
    static let selectedTextColor = UIColor.systemBlue
    static let defaultTextColor = UIColor.label
    static let selectedBorderColor = UIColor.systemBlue
    static let defaultBorderColor = UIColor.lightGray
}

private extension CGSize {
    static let shadowOffset = CGSize(width: 0, height: 2)
}
