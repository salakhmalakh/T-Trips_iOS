import UIKit
import Combine

final class CreateTripViewController: UIViewController {
    public var onTripCreated: ((Trip) -> Void)?

    private let createView = CreateTripView()
    private let viewModel: CreateTripViewModel
    private var cancellables = Set<AnyCancellable>()

    private let participants = MockData.users
    private var selectedUsers: [User] = []
    private var filteredParticipants: [User] = []
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
        navigationItem.title = nil
        setupBindings()
        setupPickers()
        setupSuggestions()
        setupActions()
        dismissKeyboardOnTap()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterFromKeyboardNotifications()
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

    private func setupSuggestions() {
        let table = createView.suggestionsTableView
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "suggestCell")
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
            self?.filterParticipants()
        }, for: .editingDidBegin)
      
        createView.participantsTextField.addAction(UIAction { [weak self] _ in
            self?.filterParticipants()
        }, for: .editingChanged)
      
        createView.participantsTextField.addAction(UIAction { [weak self] _ in
            self?.createView.suggestionsTableView.isHidden = true
            self?.createView.updateSuggestionsHeight(0)
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
                        self.createView.layoutIfNeeded()
                    }
                }
            )
            self.present(alert, animated: true)
        }
        createView.tokensView.addSubview(token)
        createView.tokensView.setNeedsLayout()
        createView.layoutIfNeeded()
    }

    private func addParticipant(_ user: User) {
        selectedUsers.append(user)
        viewModel.participantIds = selectedUsers.map { $0.id }
        addToken(for: user)
        createView.participantsTextField.text = ""
        createView.participantsTextField.placeholder = selectedUsers.isEmpty ? participantsPlaceholder : nil
        createView.updateSuggestionsHeight(0)
    }

    private func filterParticipants() {
        let text = createView.participantsTextField.text?.lowercased() ?? ""
        guard !text.isEmpty else {
            filteredParticipants = []
            createView.updateSuggestionsHeight(0)
            createView.suggestionsTableView.isHidden = true
            return
        }
        filteredParticipants = availableParticipants.filter {
            $0.firstName.lowercased().contains(text) || $0.lastName.lowercased().contains(text)
        }
        createView.suggestionsTableView.isHidden = filteredParticipants.isEmpty
        createView.bringSubviewToFront(createView.suggestionsTableView)
        createView.suggestionsTableView.reloadData()
        let height = min(CGFloat(filteredParticipants.count) * 44, 132)
        createView.updateSuggestionsHeight(height)
    }
}

extension CreateTripViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredParticipants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestCell") ?? UITableViewCell(style: .default, reuseIdentifier: "suggestCell")
        cell.backgroundColor = .secondarySystemBackground
        let user = filteredParticipants[indexPath.row]
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = filteredParticipants[indexPath.row]
        filteredParticipants.removeAll()
        createView.suggestionsTableView.isHidden = true
        createView.updateSuggestionsHeight(0)
        addParticipant(user)
        createView.suggestionsTableView.reloadData()
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
