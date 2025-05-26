//
//  TripsView.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 23.05.2025.
//

import UIKit
import SnapKit

final class TripsView: UIView {
    // MARK: - Factories
    private let buttonFactory = ButtonFactory()

    // MARK: - UI Components
    let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = CGFloat.tripsFilterSpacing
        layout.sectionInset = UIEdgeInsets.cvSectionInset
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .systemBackground
        collection.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.reuseId)
        return collection
    }()

    let tableView: UITableView = {
        let table = UITableView()
        table.register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.reuseId)
        return table
    }()
    
    private let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tripsBorderColor
        return view
    }()

    public private(set) lazy var addTripButton: CustomButton = {
        let button = CustomButton()
        let model = buttonFactory.makeConfiguration(
            title: String.tripsAddButtonTitle,
            state: .addition,
            isEnabled: true
        ) {}
        button.configure(with: model)
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        [filterCollectionView, tableView, addTripButton, bottomBorder].forEach { addSubview($0) }
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground
        [filterCollectionView, tableView, addTripButton, bottomBorder].forEach { addSubview($0) }
        setupConstraints()
    }

    private func setupConstraints() {
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(CGFloat.tripsVerticalInset)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(CGFloat.tripsFilterHeight)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(filterCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomBorder.snp.top)
        }
        bottomBorder.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(CGFloat.tripsBorderWidth)
        }
        addTripButton.snp.makeConstraints { make in
            make.width.height.equalTo(CGFloat.tripsAddButtonSize)
            make.trailing.equalToSuperview().inset(CGFloat.tripsHorizontalInset)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(CGFloat.tripsVerticalInset)
        }
    }
}

// MARK: - TripsView Constants
private extension CGFloat {
    static let tripsFilterHeight: CGFloat = 44
    static let tripsFilterSpacing: CGFloat = 8
    static let tripsHorizontalInset: CGFloat = 16
    static let tripsVerticalInset: CGFloat = 16
    static let tripsBorderWidth: CGFloat = 1
    static let tripsAddButtonSize: CGFloat = 55
}

private extension UIColor {
    static let tripsBorderColor: UIColor = .systemGray6
}

private extension String {
    static let tripsAddButtonTitle: String = "+"
}

private extension UIEdgeInsets {
    static let cvSectionInset = UIEdgeInsets(
        top: 0,
        left: CGFloat.tripsHorizontalInset,
        bottom: 0,
        right: CGFloat.tripsHorizontalInset
    )
}
