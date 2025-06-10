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
        title = "notifications".localized
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
        let item = viewModel.notifications[indexPath.row]
        if item.type == .invitation {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InvitationCell.reuseId, for: indexPath) as? InvitationCell else {
                return UITableViewCell()
            }
            cell.configure(message: item.message)
            cell.onAccept = { [weak self] in
                self?.viewModel.respond(to: item, accept: true) { tableView.reloadData() }
            }
            cell.onReject = { [weak self] in
                self?.viewModel.respond(to: item, accept: false) { tableView.reloadData() }
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.reuseId, for: indexPath) as? CustomTableCell else {
                return UITableViewCell()
            }
            cell.configure(with: item.message)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.performPressAnimation(pressed: true)
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.performPressAnimation(pressed: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.notifications[indexPath.row]
        return item.type == .invitation ? .invitationRowHeight : .tvRowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.notifications[indexPath.row]
        guard item.type != .invitation else { return }
        let alert = UIAlertController(title: nil, message: item.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

private extension CGFloat {
    static let tvRowHeight: CGFloat = 100
    static let invitationRowHeight: CGFloat = 160
}
