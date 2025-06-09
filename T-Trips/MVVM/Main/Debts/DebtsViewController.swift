import UIKit
import Combine

final class DebtsViewController: UIViewController {
    private let debtsView = DebtsView()
    private let viewModel: DebtsViewModel
    private var cancellables = Set<AnyCancellable>()

    init(tripId: Int64, userId: Int64? = nil) {
        self.viewModel = DebtsViewModel(tripId: tripId, userId: userId)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = DebtsViewModel(tripId: 0)
        super.init(coder: coder)
    }

    override func loadView() {
        view = debtsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "debts".localized
        setupBindings()
        setupTable()
    }

    private func setupTable() {
        debtsView.tableView.dataSource = self
        debtsView.tableView.delegate = self
    }

    private func setupBindings() {
        viewModel.$debts
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.debtsView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension DebtsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.debts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DebtCell.reuseId, for: indexPath) as? DebtCell else {
            return UITableViewCell()
        }
        let debt = viewModel.debts[indexPath.row]
        cell.configure(with: debt)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .tvRowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let debt = viewModel.debts[indexPath.row]
        let vm = DebtDetailViewModel(debt: debt)
        let vc = DebtDetailViewController(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

private extension CGFloat {
    static let tvRowHeight: CGFloat = 100
}
