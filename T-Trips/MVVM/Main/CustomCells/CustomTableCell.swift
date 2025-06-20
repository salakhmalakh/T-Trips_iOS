//
//  CustomTableCell.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 24.05.2025.
//

import UIKit
import SnapKit

final class CustomTableCell: UITableViewCell {
    static let reuseId = String.reuseId
    
    private let iconView = UIImageView()
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
        layer.shadowOpacity = .shadowOpacity
        layer.shadowOffset = .shadowOffset
        layer.shadowRadius = .shadowRadius
        layer.masksToBounds = false
        
        [iconView, titleLabel, dateLabel].forEach { contentView.addSubview($0) }

        iconView.tintColor = .label
        iconView.contentMode = .scaleAspectFit
        
        // Label styles
        titleLabel.font = .systemFont(ofSize: .titleFontSize, weight: .medium)
        titleLabel.numberOfLines = 0
        dateLabel.font = .systemFont(ofSize: .dateFontSize, weight: .regular)
        dateLabel.textColor = UIColor.dateTextColor
        
        // Constraints
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(CGFloat.sideInset)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(CGFloat.iconSize)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.topInset)
            make.leading.equalTo(iconView.snp.trailing).offset(CGFloat.iconSpacing)
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
        iconView.isHidden = true
        titleLabel.text = trip.title
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let start = formatter.string(from: trip.startDate)
        let end = formatter.string(from: trip.endDate)
        dateLabel.text = "\(start) - \(end)"
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.topInset)
            make.leading.equalToSuperview().offset(CGFloat.sideInset)
            make.trailing.equalToSuperview().inset(CGFloat.sideInset)
        }
    }

    // MARK: - Configure for Expense
    func configure(with expense: Expense) {
        iconView.isHidden = false
        iconView.image = UIImage(systemName: expense.category.symbolName)
        let amountString = expense.amount.rubleString
        let categoryString = expense.category.localized
        titleLabel.text = "\(amountString)"
        dateLabel.text = "\(categoryString)"
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.topInset)
            make.leading.equalTo(iconView.snp.trailing).offset(CGFloat.iconSpacing)
            make.trailing.equalToSuperview().inset(CGFloat.sideInset)
        }
    }

    // MARK: - Configure with plain text
    func configure(with text: String) {
        iconView.isHidden = true
        titleLabel.text = text
        dateLabel.text = nil
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.topInset)
            make.leading.equalToSuperview().offset(CGFloat.sideInset)
            make.trailing.equalToSuperview().inset(CGFloat.sideInset)
        }
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
    static let iconSize: CGFloat = 24
    static let iconSpacing: CGFloat = 8
    static let titleFontSize: CGFloat = 16
    static let dateFontSize: CGFloat = 14
}

private extension String {
    static let reuseId = "CustomTripCell"
}

private extension CGSize {
    static let shadowOffset = CGSize(width: 0, height: 2)
}

private extension UIEdgeInsets {
    static let contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
}

private extension UIColor {
    static let shadowColor = UIColor.black.cgColor
    static let dateTextColor = UIColor.secondaryLabel
}

private extension Float {
    static let shadowOpacity: Float = 0.1
}
