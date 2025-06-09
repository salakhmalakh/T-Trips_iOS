import UIKit
import Combine

final class NotificationsViewController: UIViewController {
    private let notificationsView = NotificationsView()
    private let viewModel = NotificationsViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = notificationsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Уведомления"
        setupTable()
    }

    private func setupTable() {
        let table = notificationsView.tableView
        table.dataSource = self
        table.delegate = self
    }
}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.reuseId, for: indexPath) as? CustomTableCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.notifications[indexPath.row].message)
        return cell
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.performPressAnimation(pressed: true)
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.performPressAnimation(pressed: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .tvRowHeight
    }
}

private extension CGFloat {
    static let tvRowHeight: CGFloat = 100
}
