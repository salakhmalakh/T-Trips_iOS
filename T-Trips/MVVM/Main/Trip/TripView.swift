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
        [tableView, addExpenseButton].forEach(addSubview)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground
        [tableView, addExpenseButton].forEach(addSubview)
        setupConstraints()
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
}

private extension String {
    static let tripAddExpenseButtonTitle = "+"
}
