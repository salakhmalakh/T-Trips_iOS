import UIKit

final class LanguagesViewController: UIViewController {
    private let languagesView = LanguagesView()
    private let viewModel = LanguagesViewModel()

    override func loadView() {
        view = languagesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = .languagesTitle
        setupTable()
    }

    private func setupTable() {
        let table = languagesView.tableView
        table.dataSource = self
        table.delegate = self
        table.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseId)
        table.separatorStyle = .none
    }
}

extension LanguagesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AppLanguage.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsCell.reuseId,
            for: indexPath
        ) as? SettingsCell else { return UITableViewCell() }
        let lang = AppLanguage.allCases[indexPath.row]
        let accessory: UIView? = {
            if lang == viewModel.currentLanguage {
                let check = UIImageView(image: UIImage(systemName: "checkmark"))
                check.tintColor = .tertiaryLabel
                return check
            }
            return nil
        }()
        cell.configure(text: lang.title, accessoryView: accessory)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.currentLanguage = AppLanguage.allCases[indexPath.row]
        tableView.reloadData()
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = scene.delegate as? SceneDelegate,
              let window = delegate.window else { return }
        let startVC = StartViewController()
        let nav = UINavigationController(rootViewController: startVC)
        nav.navigationBar.prefersLargeTitles = true
        window.rootViewController = nav
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat.rowHeight
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.performPressAnimation(pressed: true)
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.performPressAnimation(pressed: false)
    }
}

private extension CGFloat {
    static let rowHeight: CGFloat = 60
}

private extension String {
    static var languagesTitle: String { "languages".localized }
}
