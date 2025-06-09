import UIKit
import SnapKit

final class DebtsView: UIView {
    let tableView: UITableView = {
        let table = UITableView()
        table.register(DebtCell.self, forCellReuseIdentifier: DebtCell.reuseId)
        return table
    }()

    let emptyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.isHidden = true
        label.text = "noDebts".localized
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(tableView)
        addSubview(emptyLabel)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground
        addSubview(tableView)
        addSubview(emptyLabel)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
