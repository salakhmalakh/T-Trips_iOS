import UIKit

final class DebtDetailViewController: UIViewController {
    private let detailView = DebtDetailView()
    private let viewModel: DebtDetailViewModel

    init(viewModel: DebtDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Долг"
        detailView.infoLabel.text = viewModel.infoText
        detailView.confirmButton.addAction(
            UIAction { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            },
            for: .touchUpInside
        )
    }
}
