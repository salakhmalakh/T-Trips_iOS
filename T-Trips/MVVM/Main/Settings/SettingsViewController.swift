import UIKit

final class SettingsViewController: UIViewController {
    private let settingsView = SettingsView()
    private let viewModel = SettingsViewModel()

    override func loadView() {
        view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "settings".localized
        setupTable()
    }

    private func setupTable() {
        let table = settingsView.tableView
        table.dataSource = self
        table.delegate = self
        table.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseId)
        table.separatorStyle = .none
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsCell.reuseId,
            for: indexPath
        ) as? SettingsCell else {
            return UITableViewCell()
        }

        if indexPath.section == 0 {
            cell.configure(text: "editData".localized)
        } else if indexPath.row == 0 {
            let switcher = UISwitch()
            switcher.isOn = viewModel.darkMode
            switcher.addTarget(self, action: #selector(themeChanged(_:)), for: .valueChanged)
            cell.configure(text: "darkTheme".localized, accessoryView: switcher)
        } else {
            let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
            arrow.tintColor = .tertiaryLabel
            cell.configure(text: "language".localized, accessoryView: arrow)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let editVC = EditProfileViewController()
            navigationController?.pushViewController(editVC, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 1 {
            let langVC = LanguagesViewController()
            navigationController?.pushViewController(langVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.performPressAnimation(pressed: true)
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.performPressAnimation(pressed: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat.rowHeight
    }

    @objc private func themeChanged(_ sender: UISwitch) {
        viewModel.darkMode = sender.isOn
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = scene.delegate as? SceneDelegate,
              let window = delegate.window else { return }
        window.overrideUserInterfaceStyle = sender.isOn ? .dark : .light
    }
}

private extension CGFloat {
    static let rowHeight: CGFloat = 60
}

