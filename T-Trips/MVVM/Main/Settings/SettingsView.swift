import UIKit
import SnapKit

final class SettingsView: UIView {
    let tableView: UITableView = {
        let table = UITableView()
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
