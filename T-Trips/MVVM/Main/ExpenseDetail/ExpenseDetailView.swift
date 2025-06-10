//
//  ExpenseDetailView.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 27.05.2025.
//

import UIKit
import SnapKit

final class ExpenseDetailView: UIView {
    // MARK: - UI Components
    private let containerView = UIView()
    let categoryTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "categoryTitle".localized
        lbl.font = .systemFont(ofSize: CGFloat.titleFontSize, weight: .regular)
        lbl.textColor = UIColor.label.withAlphaComponent(CGFloat.titleAlpha)
        return lbl
    }()

    let categoryLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: CGFloat.categoryFontSize, weight: .medium)
        lbl.numberOfLines = 0
        return lbl
    }()

    let amountTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "amountTitle".localized
        lbl.font = .systemFont(ofSize: CGFloat.titleFontSize, weight: .regular)
        lbl.textColor = UIColor.label.withAlphaComponent(CGFloat.titleAlpha)
        return lbl
    }()

    let amountLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: CGFloat.amountFontSize, weight: .bold)
        lbl.numberOfLines = 0
        return lbl
    }()

    let dateTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "dateTitle".localized
        lbl.font = .systemFont(ofSize: CGFloat.titleFontSize, weight: .regular)
        lbl.textColor = UIColor.label.withAlphaComponent(CGFloat.titleAlpha)
        return lbl
    }()

    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: CGFloat.infoFontSize, weight: .regular)
        lbl.numberOfLines = 0
        return lbl
    }()

    let payerTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "payerTitle".localized
        lbl.font = .systemFont(ofSize: CGFloat.titleFontSize, weight: .regular)
        lbl.textColor = UIColor.label.withAlphaComponent(CGFloat.titleAlpha)
        return lbl
    }()

    let payerLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: CGFloat.infoFontSize, weight: .regular)
        lbl.numberOfLines = 0
        return lbl
    }()

    let payeeTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "payeeTitle".localized
        lbl.font = .systemFont(ofSize: CGFloat.titleFontSize, weight: .regular)
        lbl.textColor = UIColor.label.withAlphaComponent(CGFloat.titleAlpha)
        return lbl
    }()

    let payeeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: CGFloat.infoFontSize, weight: .regular)
        lbl.numberOfLines = 0
        return lbl
    }()

    let deleteButton: CustomButton = {
        let btn = CustomButton()
        let model = ButtonFactory().makeConfiguration(
            title: String.deleteButtonTitle,
            state: .primary,
            isEnabled: true
        ) {}
        btn.configure(with: model)
        return btn
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appBackground
        addSubview(containerView)
        [
            categoryTitleLabel, categoryLabel,
            amountTitleLabel, amountLabel,
            dateTitleLabel, dateLabel,
            payerTitleLabel, payerLabel,
            payeeTitleLabel, payeeLabel
        ].forEach(containerView.addSubview)
        addSubview(deleteButton)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .appBackground
        addSubview(containerView)
        [
            categoryTitleLabel, categoryLabel,
            amountTitleLabel, amountLabel,
            dateTitleLabel, dateLabel,
            payerTitleLabel, payerLabel,
            payeeTitleLabel, payeeLabel
        ].forEach(containerView.addSubview)
        addSubview(deleteButton)
        setupUI()
        setupConstraints()
    }

    private func setupConstraints() {
        let inset = CGFloat.horizontalInset
        containerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(CGFloat.topInset)
            make.leading.trailing.equalToSuperview().inset(inset)
        }
        categoryTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.contentTop)
            make.leading.trailing.equalToSuperview().inset(inset)
        }
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryTitleLabel.snp.bottom).offset(CGFloat.rowSpacing)
            make.leading.trailing.equalTo(categoryTitleLabel)
        }
        amountTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(CGFloat.sectionSpacing)
            make.leading.trailing.equalTo(categoryTitleLabel)
        }
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(amountTitleLabel.snp.bottom).offset(CGFloat.rowSpacing)
            make.leading.trailing.equalTo(categoryTitleLabel)
        }
        dateTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(CGFloat.sectionSpacing)
            make.leading.trailing.equalTo(categoryTitleLabel)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTitleLabel.snp.bottom).offset(CGFloat.rowSpacing)
            make.leading.trailing.equalTo(categoryTitleLabel)
        }
        payerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(CGFloat.sectionSpacing)
            make.leading.trailing.equalTo(categoryTitleLabel)
        }
        payerLabel.snp.makeConstraints { make in
            make.top.equalTo(payerTitleLabel.snp.bottom).offset(CGFloat.rowSpacing)
            make.leading.trailing.equalTo(categoryTitleLabel)
        }
        payeeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(payerLabel.snp.bottom).offset(CGFloat.sectionSpacing)
            make.leading.trailing.equalTo(categoryTitleLabel)
        }
        payeeLabel.snp.makeConstraints { make in
            make.top.equalTo(payeeTitleLabel.snp.bottom).offset(CGFloat.rowSpacing)
            make.leading.trailing.equalTo(categoryTitleLabel)
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(CGFloat.buttonTop)
            make.leading.trailing.equalToSuperview().inset(inset)
            make.height.equalTo(CGFloat.buttonHeight)
        }
        containerView.snp.makeConstraints { make in
            make.bottom.equalTo(payeeLabel.snp.bottom).offset(CGFloat.contentBottom)
        }
    }

    private func setupUI() {
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = CGFloat.cornerRadius
        containerView.layer.masksToBounds = true

        layer.shadowColor = UIColor.shadowColor
        layer.shadowOpacity = Float.shadowOpacity
        layer.shadowOffset = .shadowOffset
        layer.shadowRadius = .shadowRadius
        layer.masksToBounds = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(
            roundedRect: containerView.frame,
            cornerRadius: containerView.layer.cornerRadius
        ).cgPath
    }
}

// MARK: - Constants for ExpenseDetailView
private extension CGFloat {
    static let topInset: CGFloat        = 24
    static let horizontalInset: CGFloat = 16
    static let rowSpacing: CGFloat      = 8
    static let sectionSpacing: CGFloat  = 16
    static let categoryFontSize: CGFloat = 16
    static let amountFontSize: CGFloat   = 24
    static let infoFontSize: CGFloat     = 14
    static let titleFontSize: CGFloat    = 12
    static let titleAlpha: CGFloat       = 0.6
    static let buttonTop: CGFloat        = 24
    static let buttonHeight: CGFloat     = 50
    static let buttonWidth: CGFloat      = 100
    static let cornerRadius: CGFloat     = 12
    static let shadowRadius: CGFloat     = 4
    static let contentTop: CGFloat       = 16
    static let contentBottom: CGFloat    = 16
}

private extension String {
    static var deleteButtonTitle: String { "deleteButtonTitle".localized }
}

private extension CGSize {
    static let shadowOffset = CGSize(width: 0, height: 2)
}

private extension UIColor {
    static let shadowColor = UIColor.black.cgColor
}

private extension Float {
    static let shadowOpacity: Float = 0.1
}
