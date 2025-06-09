import UIKit

final class SettingsViewController: UIViewController {
    private let settingsView = SettingsView()
    private let viewModel = SettingsViewModel()

    override func loadView() {
        view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        setupTable()
    }

    private func setupTable() {
        settingsView.tableView.dataSource = self
        settingsView.tableView.delegate = self
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .secondarySystemBackground
        if indexPath.section == 0 {
            cell.textLabel?.text = "Редактировать данные"
        } else if indexPath.row == 0 {
            cell.textLabel?.text = "Темная тема"
            let switcher = UISwitch()
            switcher.isOn = viewModel.darkMode
            switcher.addTarget(self, action: #selector(themeChanged(_:)), for: .valueChanged)
            cell.accessoryView = switcher
        } else {
            cell.textLabel?.text = "Язык"
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }

    @objc private func themeChanged(_ sender: UISwitch) {
        viewModel.darkMode = sender.isOn
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = scene.delegate as? SceneDelegate,
              let window = delegate.window else { return }
        window.overrideUserInterfaceStyle = sender.isOn ? .dark : .light
    }
}
