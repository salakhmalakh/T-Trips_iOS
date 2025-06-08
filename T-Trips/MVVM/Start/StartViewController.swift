import UIKit
import Combine

final class StartViewController: UIViewController {
    private let startView = StartView()
    private let viewModel = StartViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = startView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.start()
    }

    private func bindViewModel() {
        viewModel.onFinish = { [weak self] in
            let authVC = AuthViewController()
            self?.navigationController?.setViewControllers([authVC], animated: true)
        }
    }
}
