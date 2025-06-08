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
    let categoryTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Категория"
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
        lbl.text = "Сумма"
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
        lbl.text = "Дата"
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
        lbl.text = "Кто оплатил"
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
        lbl.text = "За кого оплачено"
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
        backgroundColor = .systemBackground
        [
            categoryTitleLabel, categoryLabel,
            amountTitleLabel, amountLabel,
            dateTitleLabel, dateLabel,
            payerTitleLabel, payerLabel,
            payeeTitleLabel, payeeLabel,
            deleteButton
        ].forEach(addSubview)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground
        [
            categoryTitleLabel, categoryLabel,
            amountTitleLabel, amountLabel,
            dateTitleLabel, dateLabel,
            payerTitleLabel, payerLabel,
            payeeTitleLabel, payeeLabel,
            deleteButton
        ].forEach(addSubview)
        setupConstraints()
    }

    private func setupConstraints() {
        let inset = CGFloat.horizontalInset
        categoryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(CGFloat.topInset)
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
            make.top.equalTo(payeeLabel.snp.bottom).offset(CGFloat.sectionSpacing)
            make.leading.trailing.equalToSuperview().inset(inset)
            make.height.equalTo(CGFloat.buttonHeight)
        }
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
}

private extension String {
    static let deleteButtonTitle = "Удалить"
}
