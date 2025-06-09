//
//  ExpenseDetailViewController.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 27.05.2025.
//

import UIKit
import Combine

final class ExpenseDetailViewController: UIViewController {
    private let detailView = ExpenseDetailView()
    private let viewModel: ExpenseDetailViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: ExpenseDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String.detailTitle
        bindViewModel()
        setupActions()
    }

    private func bindViewModel() {
        viewModel.$category
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.detailView.categoryLabel.text = text
            }
            .store(in: &cancellables)

        viewModel.$amountText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.detailView.amountLabel.text = text
            }
            .store(in: &cancellables)

        viewModel.$dateText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.detailView.dateLabel.text = text
            }
            .store(in: &cancellables)

        viewModel.$payer
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.detailView.payerLabel.text = text
            }
            .store(in: &cancellables)

        viewModel.$payee
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.detailView.payeeLabel.text = text
            }
            .store(in: &cancellables)
    }

    private func setupActions() {
        detailView.deleteButton.addAction(
            UIAction { [weak self] _ in self?.viewModel.deleteTapped() }, for: .touchUpInside
        )
    }
}

// MARK: - Constants
private extension String {
    static var detailTitle: String { "expenseDetailTitle".localized }
    static var editButtonTitle: String { "editButtonTitle".localized }
    static var deleteButtonTitle: String { "deleteButtonTitle".localized }
}
