import UIKit

final class DebtsViewController: UIViewController {
    private let debtsView = DebtsView()
    private let viewModel = DebtsViewModel()

    override func loadView() {
        view = debtsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Долги"
        setupTable()
    }

    private func setupTable() {
        debtsView.tableView.dataSource = self
        debtsView.tableView.delegate = self
    }
}

extension DebtsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.debts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.reuseId, for: indexPath) as? CustomTableCell else {
            return UITableViewCell()
        }
        let debt = viewModel.debts[indexPath.row]
        let text = "\(debt.fromUserId) -> \(debt.toUserId) \(debt.amount)₽"
        cell.configure(with: text)
        return cell
    }
}
