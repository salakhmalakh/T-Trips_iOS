import UIKit
import Combine

final class CreateTripViewController: UIViewController {
    public var onTripCreated: ((Trip) -> Void)?

    private let createView = CreateTripView()
    private let viewModel: CreateTripViewModel
    private var cancellables = Set<AnyCancellable>()

    private var selectedUsers: [User] = []
    private let participantsPlaceholder = "Участники"

    init() {
        self.viewModel = CreateTripViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = CreateTripViewModel()
        super.init(coder: coder)
    }

    override func loadView() {
        view = createView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = nil
        setupBindings()
        setupPickers()
        setupActions()
    }

    private func setupBindings() {
        viewModel.$isSaveEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] enabled in
                self?.createView.saveButton.isEnabled = enabled
            }
            .store(in: &cancellables)

        viewModel.$startDate
            .receive(on: RunLoop.main)
            .sink { [weak self] date in
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                self?.createView.startDateTextField.text = formatter.string(from: date)
            }
            .store(in: &cancellables)

        viewModel.$endDate
            .receive(on: RunLoop.main)
            .sink { [weak self] date in
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                self?.createView.endDateTextField.text = formatter.string(from: date)
            }
            .store(in: &cancellables)
    }

    private func setupPickers() {
        createView.startDatePicker.addTarget(self, action: #selector(startDateChanged(_:)), for: .valueChanged)
        createView.endDatePicker.addTarget(self, action: #selector(endDateChanged(_:)), for: .valueChanged)
    }

    @objc private func startDateChanged(_ picker: UIDatePicker) {
        viewModel.startDate = picker.date
    }

    @objc private func endDateChanged(_ picker: UIDatePicker) {
        viewModel.endDate = picker.date
    }

    private func setupActions() {
        createView.titleTextField.addAction(UIAction { [weak self] _ in
            self?.viewModel.title = self?.createView.titleTextField.text ?? ""
        }, for: .editingChanged)

        createView.budgetTextField.addAction(UIAction { [weak self] _ in
            self?.viewModel.budget = self?.createView.budgetTextField.text ?? ""
        }, for: .editingChanged)

        createView.descriptionTextView.delegate = self

        createView.participantsTextField.addAction(UIAction { [weak self] _ in
            self?.findParticipant()
        }, for: .editingDidEndOnExit)
        createView.participantsTextField.addAction(UIAction { [weak self] _ in
            self?.findParticipant()
        }, for: .editingDidEnd)

        createView.saveButton.addAction(UIAction { [weak self] _ in
            self?.viewModel.saveTrip()
        }, for: .touchUpInside)

        viewModel.onTripCreated = { [weak self] trip in
            guard let self = self else { return }
            self.onTripCreated?(trip)
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func addToken(for user: User) {
        let token = ParticipantTokenView(name: "\(user.firstName) \(user.lastName)")
        token.onRemove = { [weak self, weak token] in
            guard let self = self, let token = token else { return }
            let alert = UIAlertController(
                title: nil,
                message: String.deleteConfirmation,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: String.cancelTitle, style: .cancel))
            alert.addAction(
                UIAlertAction(title: String.confirmButtonTitle, style: .destructive) { _ in
                    if let index = self.selectedUsers.firstIndex(where: { $0.id == user.id }) {
                        self.selectedUsers.remove(at: index)
                        self.viewModel.participantIds = self.selectedUsers.map { $0.id }
                        token.removeFromSuperview()
                        self.createView.participantsTextField.placeholder = self.selectedUsers.isEmpty ? self.participantsPlaceholder : nil
                        self.createView.tokensView.setNeedsLayout()
                    }
                }
            )
            self.present(alert, animated: true)
        }
        createView.tokensView.addSubview(token)
        createView.tokensView.setNeedsLayout()
    }

    private func addParticipant(_ user: User) {
        selectedUsers.append(user)
        viewModel.participantIds = selectedUsers.map { $0.id }
        addToken(for: user)
        createView.participantsTextField.text = ""
        createView.participantsTextField.placeholder = selectedUsers.isEmpty ? participantsPlaceholder : nil
    }

    private func findParticipant() {
        let text = createView.participantsTextField.text ?? ""
        let digits = text.filter { $0.isNumber }
        guard !digits.isEmpty else { return }
        let phone = "+" + digits
        NetworkAPIService.shared.findParticipant(phone: phone) { [weak self] user in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let user = user, !self.selectedUsers.contains(where: { $0.id == user.id }) {
                    self.addParticipant(user)
                }
            }
        }
    }
}

extension CreateTripViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.description = textView.text
    }
}

// MARK: - Constants
private extension String {
    static var cancelTitle: String { "cancelButtonTitle".localized }
    static var deleteConfirmation: String { "deleteConfirmation".localized }
    static var confirmButtonTitle: String { "confirmButtonTitle".localized }
}
