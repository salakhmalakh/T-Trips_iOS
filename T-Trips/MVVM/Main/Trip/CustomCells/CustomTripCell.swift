//
//  CustomTripCell.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 24.05.2025.
//

import UIKit
import SnapKit

final class CustomTripCell: UITableViewCell {
    static let reuseId = String.reuseId

    private let titleLabel = UILabel()
    private let dateLabel = UILabel()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        // Configure contentView
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = .cornerRadius
        contentView.layer.masksToBounds = true

        // Shadow on cell layer
        layer.shadowColor = UIColor.shadowColor
        layer.shadowOpacity = Float.shadowOpacity
        layer.shadowOffset = .shadowOffset
        layer.shadowRadius = .shadowRadius
        layer.masksToBounds = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)

        // Label styles
        titleLabel.font = .systemFont(ofSize: .titleFontSize, weight: .medium)
        titleLabel.numberOfLines = 0
        dateLabel.font = .systemFont(ofSize: .dateFontSize, weight: .regular)
        dateLabel.textColor = .dateTextColor

        // Constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.topInset)
            make.leading.equalToSuperview().offset(CGFloat.sideInset)
            make.trailing.equalToSuperview().inset(CGFloat.sideInset)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.labelSpacing)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(CGFloat.bottomInset)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets.contentInset)
        layer.shadowPath = UIBezierPath(
            roundedRect: contentView.frame,
            cornerRadius: contentView.layer.cornerRadius
        ).cgPath
    }

    // MARK: - Configure for Trip
    func configure(with trip: Trip) {
        titleLabel.text = trip.title
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let start = formatter.string(from: trip.startDate)
        let end = trip.endDate.map { formatter.string(from: $0) } ?? ""
        dateLabel.text = end.isEmpty ? start : "\(start) - \(end)"
    }

    // MARK: - Configure for Expense
    func configure(with expense: Expense) {
        let amountString = expense.amount.rubleString
        let categoryString = expense.category.localized
        titleLabel.text = "\(amountString) — \(categoryString)"

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = formatter.string(from: expense.createdAt)
    }
}

// MARK: - Constants
private extension CGFloat {
    static let cornerRadius: CGFloat = 12
    static let shadowRadius: CGFloat = 4
    static let topInset: CGFloat = 16
    static let bottomInset: CGFloat = 16
    static let sideInset: CGFloat = 16
    static let labelSpacing: CGFloat = 8
    static let titleFontSize: CGFloat = 16
    static let dateFontSize: CGFloat = 14
}

private extension Float {
    static let shadowOpacity: Float = 0.1
}

private extension String {
    static let reuseId = "CustomTripCell"
}

private extension UIColor {
    static let shadowColor = UIColor.black.cgColor
    static let dateTextColor = UIColor.secondaryLabel
}

private extension UIEdgeInsets {
    static let contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
}

private extension CGSize {
    static let shadowOffset = CGSize(width: 0, height: 2)
}
