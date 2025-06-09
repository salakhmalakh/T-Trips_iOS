//
//  TripsViewController.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 23.05.2025.
//

import UIKit
import Combine

final class TripsViewController: UIViewController {
    private let tripsView = TripsView()
    private let viewModel = TripsViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = tripsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = .tripsTitle
        setupBindings()
        setupActions()
        setupTable()
        updateFilterSelection()
    }

    private func setupBindings() {
        viewModel.$filteredTrips
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tripsView.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$filter
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateFilterSelection()
            }
            .store(in: &cancellables)
    }

    private func setupActions() {
        tripsView.filterCollectionView.dataSource = self
        tripsView.filterCollectionView.delegate = self
        tripsView.addTripButton.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.addTripTapped()
            },
            for: .touchUpInside
        )

        viewModel.onAddTrip = { [weak self] in
            guard let self = self else { return }
            let adminId = MockAPIService.shared.currentUser?.id ?? 0
            let createVC = CreateTripViewController(adminId: adminId)
            createVC.onTripCreated = { [weak self] trip in
                self?.viewModel.addTrip(trip)
            }
            createVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(createVC, animated: true)
        }
    }

    private func updateFilterSelection() {
        tripsView.filterCollectionView.reloadData()
    }

    private func setupTable() {
        let table = tripsView.tableView
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
    }
}

extension TripsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        TripsViewModel.Filter.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FilterCell.reuseId,
            for: indexPath
        ) as? FilterCell else {
            return UICollectionViewCell()
        }
        let filter = TripsViewModel.Filter(rawValue: indexPath.item) ?? .active
        cell.configure(
            title: filter.title,
            selected: filter == viewModel.filter
        )
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let filter = TripsViewModel.Filter(rawValue: indexPath.item) {
            viewModel.filter = filter
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let filter = TripsViewModel.Filter(rawValue: indexPath.item) ?? .active
        let width = filter.title.size(
            withAttributes: [.font: UIFont.systemFont(ofSize: CGFloat.filterFontSize, weight: .medium)]
        ).width + CGFloat.cvItemExpander
        return CGSize(width: width, height: CGFloat.filterHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.performPressAnimation(pressed: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.performPressAnimation(pressed: false)
    }
}

extension TripsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredTrips.count
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
        cell.configure(with: viewModel.filteredTrips[indexPath.row])
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .tvRowHeight
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.performPressAnimation(pressed: true)
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.performPressAnimation(pressed: false)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let trip = viewModel.filteredTrips[indexPath.row]
        
        let tripVM = TripViewModel(trip: trip)
        
        let tripVC = TripViewController(viewModel: tripVM)
        tripVC.hidesBottomBarWhenPushed = true

        navigationController?.pushViewController(tripVC, animated: true)
    }
}

// MARK: - Constants
private extension CGFloat {
    static let filterFontSize: CGFloat = 14
    static let filterHeight: CGFloat = 36
    static let tvRowHeight: CGFloat = 100
    static let cvItemExpander: CGFloat = 32
}

private extension String {
    static var tripsTitle: String { "trips".localized }
}
