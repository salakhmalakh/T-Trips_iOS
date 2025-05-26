//
//  TripViewController.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 26.05.2025.
//

import UIKit
import Combine

final class TripViewController: UIViewController {
    private let tripView = TripView()
    private let viewModel: TripViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: TripViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = tripView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = .tripTitile
        setupBindings()
        setupActions()
        setupTableView()
    }

    // MARK: - Setup
    private func setupBindings() {
        viewModel.$expenses
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tripView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func setupActions() {
        tripView.addExpenseButton.addAction(
            UIAction { [weak self] _ in self?.viewModel.addExpenseTapped() },
            for: .touchUpInside
        )
        viewModel.onAddExpense = { 
            // TODO: present add expense screen
        }
    }

    private func setupTableView() {
        let table = tripView.tableView
        table.dataSource = self
        table.delegate = self
    }
}

// MARK: - UITableViewDataSource & Delegate
extension TripViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.expenses.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableCell.reuseId,
            for: indexPath
        ) as? CustomTableCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.expenses[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.performPressAnimation(pressed: true)
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.performPressAnimation(pressed: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .tvCellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: navigate to expense detail
    }
}

// MARK: - Constants
private extension CGFloat {
    static let tvCellHeight: CGFloat = 100
}

private extension String {
    static let tripTitile = "Поездка"
}
