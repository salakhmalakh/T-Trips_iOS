import UIKit
import Combine

final class TripDetailViewController: UIViewController {
    private let detailView = TripDetailView()
    private let viewModel: TripDetailViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: TripDetailViewModel) {
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
        title = "Детали поездки"
        bind()
    }

    private func bind() {
        detailView.titleLabel.text = viewModel.title
        detailView.startLabel.text = viewModel.startText
        detailView.endLabel.text = viewModel.endText
        detailView.budgetLabel.text = viewModel.budgetText
        detailView.participantsLabel.text = viewModel.participants
        detailView.descriptionLabel.text = viewModel.description
    }
}
