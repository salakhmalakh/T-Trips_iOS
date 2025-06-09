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
        if viewModel.trip.status == .completed {
            tripView.addExpenseButton.isHidden = true
        }
        setupNavigationBar()
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
        viewModel.onAddExpense = { [weak self] in
            guard let self = self else { return }
            let ids = self.viewModel.trip.participantIds ?? []
            let participants = MockData.users.filter { ids.contains($0.id) }
            let addVC = AddExpenseViewController(
                tripId: self.viewModel.trip.id,
                participants: participants
            )
            addVC.onExpenseAdded = { [weak self] expense in
                self?.viewModel.addExpense(expense)
            }
            
            addVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }

    private func setupTableView() {
        let table = tripView.tableView
        table.dataSource = self
        table.delegate = self
    }

    // MARK: - Navigation bar
    private func setupNavigationBar() {
        let details = UIAction(title: String.detailsTitle) { [weak self] _ in
            self?.showTripDetails()
        }
        let debts = UIAction(title: String.debtsTitle) { [weak self] _ in
            self?.showDebts()
        }
        let exit = UIAction(title: String.exitTitle, attributes: .destructive) { [weak self] _ in
            self?.exitTrip()
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            menu: UIMenu(children: [details, debts, exit])
        )
    }

    private func showTripDetails() {
        let vm = TripDetailViewModel(trip: viewModel.trip, users: MockData.users)
        let vc = TripDetailViewController(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showDebts() {
        let vc = DebtsViewController(tripId: viewModel.trip.id)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    private func exitTrip() {
        navigationController?.popViewController(animated: true)
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
        let expense = viewModel.expenses[indexPath.row]
        
        // Кто оплатил
        let payerName: String = {
            if let owner = expense.owner {
                return "\(owner.firstName) \(owner.lastName)"
            }
            return ""
        }()
        
        // За кого оплачено — список через запятую
        let payeeName: String = {
            let names = expense.paidForUsers
                .map { "\($0.firstName) \($0.lastName)" }
            return names.joined(separator: ", ")
        }()
        
        // Передаём оба имени в Detail ViewModel
        let detailVM = ExpenseDetailViewModel(
            expense: expense,
            payerName: payerName,
            payeeName: payeeName
        )
        let detailVC = ExpenseDetailViewController(viewModel: detailVM)
        detailVM.onDelete = { [weak self] in
            self?.viewModel.deleteExpense(at: indexPath.row)
            self?.navigationController?.popViewController(animated: true)
        }
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteExpense(at: indexPath.row)
        }
    }
}

// MARK: - Constants
private extension CGFloat {
    static let tvCellHeight: CGFloat = 100
}

private extension String {
    static var tripTitile: String { "trip".localized }
    static var detailsTitle: String { "details".localized }
    static var debtsTitle: String { "debts".localized }
    static var exitTitle: String { "logout".localized }
}
