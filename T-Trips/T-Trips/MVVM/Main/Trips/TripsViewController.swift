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
        title = "Поездки"
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
            withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)]
        ).width + 32
        return CGSize(width: width, height: 36)
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
            withIdentifier: CustomTripCell.reuseId,
            for: indexPath
        ) as? CustomTripCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.filteredTrips[indexPath.row])
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        // TODO: navigate to trip detail
    }
}
