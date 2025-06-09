import UIKit
import Combine

final class CreateTripViewController: UIViewController {
    public var onTripCreated: ((Trip) -> Void)?

    private let createView = CreateTripView()
    private let viewModel: CreateTripViewModel
    private var cancellables = Set<AnyCancellable>()

    private let participants = MockData.users
    private var selectedUsers: [User] = []
    private let participantsPlaceholder = "Участники"
    private var availableParticipants: [User] {
        participants.filter { user in
            !selectedUsers.contains(where: { $0.id == user.id })
        }
    }

    init(adminId: Int64 = 0) {
        self.viewModel = CreateTripViewModel(adminId: adminId)
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
        title = "Создание поездки"
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
        createView.participantsPicker.dataSource = self
        createView.participantsPicker.delegate = self
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

        createView.descriptionTextField.addAction(UIAction { [weak self] _ in
            self?.viewModel.description = self?.createView.descriptionTextField.text ?? ""
        }, for: .editingChanged)

        createView.participantsTextField.addAction(UIAction { [weak self] _ in
                      guard let self = self else { return }
            let row = self.createView.participantsPicker.selectedRow(inComponent: 0)
            guard self.availableParticipants.indices.contains(row) else { return }
            let user = self.availableParticipants[row]
            self.selectedUsers.append(user)
            self.viewModel.participantIds = self.selectedUsers.map { $0.id }
            self.addToken(for: user)
            self.createView.participantsPicker.reloadAllComponents()
            self.createView.participantsTextField.text = ""
            self.createView.participantsTextField.placeholder = self.selectedUsers.isEmpty ? self.participantsPlaceholder : nil
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
            if let index = self.selectedUsers.firstIndex(where: { $0.id == user.id }) {
                self.selectedUsers.remove(at: index)
                self.viewModel.participantIds = self.selectedUsers.map { $0.id }
                token.removeFromSuperview()
                self.createView.participantsTextField.placeholder = self.selectedUsers.isEmpty ? self.participantsPlaceholder : nil
                self.createView.participantsPicker.reloadAllComponents()
                self.createView.tokensView.setNeedsLayout()
            }
        }
        createView.tokensView.addSubview(token)
        createView.tokensView.setNeedsLayout()
    }
}

extension CreateTripViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        availableParticipants.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let user = availableParticipants[row]
        return "\(user.firstName) \(user.lastName)"
    }
}
