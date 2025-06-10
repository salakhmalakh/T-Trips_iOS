import UIKit
import SnapKit

final class NotificationsView: UIView {
    let tableView: UITableView = {
        let table = UITableView()
        table.register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.reuseId)
        table.register(InvitationCell.self, forCellReuseIdentifier: InvitationCell.reuseId)
        table.backgroundColor = .appBackground
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appBackground
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .appBackground
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
