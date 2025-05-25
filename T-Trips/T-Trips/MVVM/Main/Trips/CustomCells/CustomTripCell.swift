//
//  CustomTripCell.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 24.05.2025.
//

import UIKit
import SnapKit

final class CustomTripCell: UITableViewCell {
    static let reuseId = Constants.reuseId

    private let titleLabel = UILabel()
    private let dateLabel = UILabel()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        // Configure contentView
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.masksToBounds = true

        // Shadow on cell layer
        layer.shadowColor = Constants.shadowColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowRadius = Constants.shadowRadius
        layer.masksToBounds = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)

        // Label styles
        titleLabel.font = .systemFont(ofSize: Constants.titleFontSize, weight: .medium)
        titleLabel.numberOfLines = 0
        dateLabel.font = .systemFont(ofSize: Constants.dateFontSize, weight: .regular)
        dateLabel.textColor = Constants.dateTextColor

        // Constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.topInset)
            make.leading.equalToSuperview().offset(Constants.sideInset)
            make.trailing.equalToSuperview().inset(Constants.sideInset)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.labelSpacing)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(Constants.bottomInset)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: Constants.contentInset)
        layer.shadowPath = UIBezierPath(
            roundedRect: contentView.frame,
            cornerRadius: contentView.layer.cornerRadius
        ).cgPath
    }

    // MARK: - Configure
    func configure(with trip: Trip) {
        titleLabel.text = trip.title
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let start = formatter.string(from: trip.startDate)
        let end = trip.endDate.map { formatter.string(from: $0) } ?? ""
        dateLabel.text = end.isEmpty ? start : "\(start) - \(end)"
    }
}

// MARK: - Constants
private extension CustomTripCell {
    enum Constants {
        static let reuseId = "CustomTripCell"
        static let cornerRadius: CGFloat = 12
        static let shadowColor = UIColor.black.cgColor
        static let shadowOpacity: Float = 0.1
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let shadowRadius: CGFloat = 4
        static let contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        static let topInset: CGFloat = 16
        static let bottomInset: CGFloat = 16
        static let sideInset: CGFloat = 16
        static let labelSpacing: CGFloat = 8
        static let titleFontSize: CGFloat = 16
        static let dateFontSize: CGFloat = 14
        static let dateTextColor = UIColor.secondaryLabel
    }
}
