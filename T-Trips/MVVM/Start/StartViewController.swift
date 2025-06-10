import UIKit
import Combine

final class StartViewController: UIViewController {
    private let startView = StartView()
    private let viewModel = StartViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let finishAction: (() -> Void)?

    init(finishAction: (() -> Void)? = nil) {
        self.finishAction = finishAction
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
            if let action = self?.finishAction {
                action()
            } else {
                let authVC = AuthViewController()
                self?.navigationController?.setViewControllers([authVC], animated: true)
            }
        }
    }
}
