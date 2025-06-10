//
//  TripView.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 26.05.2025.
//

import UIKit
import SnapKit

final class TripView: UIView {
    // MARK: - UI Components
    let headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: CGFloat.headerFont, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    let tableView: UITableView = {
        let table = UITableView()
        table.register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.reuseId)
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        return table
    }()

    let addExpenseButton: CustomButton = {
        let button = CustomButton()
        let model = ButtonModel(
            title: String.tripAddExpenseButtonTitle,
            state: .addition,
            isEnabled: true,
            action: nil
        )
        button.configure(with: model)
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        [headerLabel, tableView, addExpenseButton].forEach(addSubview)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground
        [headerLabel, tableView, addExpenseButton].forEach(addSubview)
        setupConstraints()
    }

    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(CGFloat.headerTopInset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.headerSideInset)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(CGFloat.tableTopInset)
            make.leading.trailing.bottom.equalToSuperview()
        }
        addExpenseButton.snp.makeConstraints { make in
            make.width.height.equalTo(CGFloat.tripAddButtonSize)
            make.trailing.equalToSuperview().inset(CGFloat.tripHorizontalInset)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(CGFloat.tripVerticalInset)
        }
    }
}

// MARK: - TripView Constants
private extension CGFloat {
    static let tripAddButtonSize: CGFloat   = 55
    static let tripHorizontalInset: CGFloat = 16
    static let tripVerticalInset: CGFloat   = 16
    static let headerTopInset: CGFloat      = 16
    static let headerSideInset: CGFloat     = 16
    static let headerFont: CGFloat          = 24
    static let tableTopInset: CGFloat       = 8
}

private extension String {
    static let tripAddExpenseButtonTitle = "+"
}
