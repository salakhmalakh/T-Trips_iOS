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
        detailView.creditorLabel.text = viewModel.creditorName
        detailView.amountLabel.text = viewModel.amountText
        detailView.requisitesLabel.text = viewModel.creditorPhone
        detailView.tripLabel.text = viewModel.tripTitle
        detailView.payButton.isHidden = !viewModel.showsPayButton
        detailView.payButton.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.payTapped()
            },
            for: .touchUpInside
        )
    }
}
