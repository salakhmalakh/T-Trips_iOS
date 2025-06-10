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
    func numberOfSections(in tableView: UITableView) -> Int { 3 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        default: return 1
        }
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
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let switcher = UISwitch()
                switcher.isOn = viewModel.darkMode
                switcher.addTarget(self, action: #selector(themeChanged(_:)), for: .valueChanged)
                cell.configure(text: "darkTheme".localized, accessoryView: switcher)
            } else {
                let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
                arrow.tintColor = .tertiaryLabel
                cell.configure(text: "language".localized, accessoryView: arrow)
            }
        } else {
            cell.configure(text: "logout".localized)
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
        } else if indexPath.section == 2 {
            confirmLogout()
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

    private func confirmLogout() {
        let alert = UIAlertController(
            title: nil,
            message: String.logoutConfirmation,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: String.cancelTitle, style: .cancel))
        alert.addAction(
            UIAlertAction(title: String.confirmButtonTitle, style: .destructive) { _ in
                NetworkAPIService.shared.logout()
                guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let delegate = scene.delegate as? SceneDelegate,
                      let window = delegate.window else { return }
                let startVC = StartViewController()
                let nav = UINavigationController(rootViewController: startVC)
                nav.navigationBar.prefersLargeTitles = true
                window.rootViewController = nav
            }
        )
        present(alert, animated: true)
    }
}

private extension CGFloat {
    static let rowHeight: CGFloat = 60
}

private extension String {
    static var logoutConfirmation: String { "logoutConfirmation".localized }
    static var cancelTitle: String { "cancelButtonTitle".localized }
    static var confirmButtonTitle: String { "confirmButtonTitle".localized }
}

