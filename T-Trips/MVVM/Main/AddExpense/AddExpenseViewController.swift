//
//  AddExpenseViewController.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 26.05.2025.
//

import UIKit
import Combine

final class AddExpenseViewController: UIViewController {
    // MARK: - Callback for new expense
    public var onExpenseAdded: ((Expense) -> Void)?
    
    private let addExpenseView = AddExpenseView()
    private let viewModel: AddExpenseViewModel
    private var cancellables = Set<AnyCancellable>()

    private let categories = Expense.Category.allCases
    private let participants: [User]
    private var payers: [User] { participants }
    private var selectedPayees: [User] = []
    private var tokenMap: [Int64: ParticipantTokenView] = [:]
    private var filteredPayees: [User] = []
    private let payeesPlaceholder = "addExpensePayeePlaceholder".localized
    private var availablePayees: [User] {
        participants.filter { user in
            user.id != viewModel.payerId &&
            !selectedPayees.contains(where: { $0.id == user.id })
        }
    }

    // MARK: - Init
    init(tripId: Int64, participants: [User] = []) {
        self.viewModel = AddExpenseViewModel(tripId: tripId)
        self.participants = participants
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = addExpenseView
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

    // MARK: - Bindings
    private func setupBindings() {
        viewModel.$isAddEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] enabled in
                self?.addExpenseView.addButton.isEnabled = enabled
            }
            .store(in: &cancellables)

        viewModel.$date
            .receive(on: RunLoop.main)
            .sink { [weak self] date in
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                self?.addExpenseView.dateTextField.text = formatter.string(from: date)
            }
            .store(in: &cancellables)
    }

    // MARK: - Pickers
    private func setupPickers() {
        addExpenseView.categoryTextField.addAction(
            UIAction { [weak self] _ in self?.addExpenseView.categoryTextField.becomeFirstResponder() },
            for: .editingDidBegin
        )
        addExpenseView.payerTextField.addAction(
            UIAction { [weak self] _ in self?.addExpenseView.payerTextField.becomeFirstResponder() },
            for: .editingDidBegin
        )
        addExpenseView.payeeTextField.addAction(UIAction { [weak self] _ in
            self?.filterPayees()
        }, for: .editingDidBegin)
        addExpenseView.payeeTextField.addAction(UIAction { [weak self] _ in
            self?.filterPayees()
        }, for: .editingChanged)
        addExpenseView.payeeTextField.addAction(UIAction { [weak self] _ in
            self?.addExpenseView.suggestionsTableView.isHidden = true
            self?.addExpenseView.updateSuggestionsHeight(0)
        }, for: .editingDidEnd)
        addExpenseView.dateTextField.addAction(
            UIAction { [weak self] _ in self?.addExpenseView.dateTextField.becomeFirstResponder() },
            for: .editingDidBegin
        )

        addExpenseView.categoryPicker.dataSource = self
        addExpenseView.categoryPicker.delegate = self
        addExpenseView.payerPicker.dataSource = self
        addExpenseView.payerPicker.delegate = self
        addExpenseView.datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }

    private func setupSuggestions() {
        let table = addExpenseView.suggestionsTableView
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "suggestCell")
    }

    @objc private func dateChanged(_ picker: UIDatePicker) {
        viewModel.date = picker.date
    }

    // MARK: - Actions
    private func setupActions() {
        addExpenseView.titleTextField.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.title = self?.addExpenseView.titleTextField.text ?? ""
            },
            for: .editingChanged
        )

        addExpenseView.amountTextField.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.amount = self?.addExpenseView.amountTextField.text ?? ""
            },
            for: .editingChanged
        )

        addExpenseView.categoryTextField.addAction(
            UIAction { [weak self] _ in
                let row = self?.addExpenseView.categoryPicker.selectedRow(inComponent: 0) ?? 0
                let cat = self?.categories[row] ?? .other
                self?.viewModel.category = cat.rawValue
                self?.addExpenseView.categoryTextField.text = cat.localized
            },
            for: .editingDidEnd
        )

        addExpenseView.payerTextField.addAction(
            UIAction { [weak self] _ in
                let row = self?.addExpenseView.payerPicker.selectedRow(inComponent: 0) ?? 0
                let user = self?.payers[row]
                self?.viewModel.payerId = user?.id
                self?.addExpenseView.payerTextField.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
                self?.removePayeeIfNeeded()
            },
            for: .editingDidEnd
        )


        addExpenseView.addButton.addAction(
            UIAction { [weak self] _ in self?.viewModel.addExpense() },
            for: .touchUpInside
        )

        viewModel.onAdd = { [weak self] expense in
            guard let self = self else { return }
            
            self.onExpenseAdded?(expense)
            
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func removePayeeIfNeeded() {
        guard let payerId = viewModel.payerId else { return }
        if let token = tokenMap[payerId] {
            token.onRemove?()
        }
    }

    private func addToken(for user: User) {
        let token = ParticipantTokenView(name: "\(user.firstName) \(user.lastName)")
        token.onRemove = { [weak self, weak token] in
            guard let self = self, let token = token else { return }
            if let index = self.selectedPayees.firstIndex(where: { $0.id == user.id }) {
                self.selectedPayees.remove(at: index)
                self.viewModel.payeeIds = self.selectedPayees.map { $0.id }
                self.tokenMap[user.id] = nil
                token.removeFromSuperview()
                self.addExpenseView.payeeTextField.placeholder = self.selectedPayees.isEmpty ? self.payeesPlaceholder : nil
                self.addExpenseView.tokensView.setNeedsLayout()
            }
        }
        tokenMap[user.id] = token
        addExpenseView.tokensView.addSubview(token)
        addExpenseView.tokensView.setNeedsLayout()
    }

    private func addPayee(_ user: User) {
        selectedPayees.append(user)
        viewModel.payeeIds = selectedPayees.map { $0.id }
        addToken(for: user)
        addExpenseView.payeeTextField.text = ""
        addExpenseView.payeeTextField.placeholder = selectedPayees.isEmpty ? payeesPlaceholder : nil
        addExpenseView.updateSuggestionsHeight(0)
    }

    private func filterPayees() {
        let text = addExpenseView.payeeTextField.text?.lowercased() ?? ""
        guard !text.isEmpty else {
            filteredPayees = []
            addExpenseView.updateSuggestionsHeight(0)
            addExpenseView.suggestionsTableView.isHidden = true
            return
        }
        filteredPayees = availablePayees.filter {
            $0.firstName.lowercased().contains(text) || $0.lastName.lowercased().contains(text)
        }
        addExpenseView.suggestionsTableView.isHidden = filteredPayees.isEmpty
        addExpenseView.bringSubviewToFront(addExpenseView.suggestionsTableView)
        addExpenseView.suggestionsTableView.reloadData()
        let height = min(CGFloat(filteredPayees.count) * 44, 132)
        addExpenseView.updateSuggestionsHeight(height)
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension AddExpenseViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case addExpenseView.categoryPicker:
            return categories.count
        case addExpenseView.payerPicker:
            return payers.count
        default: return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case addExpenseView.categoryPicker:
            return categories[row].localized
        case addExpenseView.payerPicker:
            let user = payers[row]
            return "\(user.firstName) \(user.lastName)"
        default: return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == addExpenseView.payerPicker {
            removePayeeIfNeeded()
        }
    }
}

extension AddExpenseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredPayees.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestCell") ?? UITableViewCell(style: .default, reuseIdentifier: "suggestCell")
        cell.backgroundColor = .secondarySystemBackground
        let user = filteredPayees[indexPath.row]
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = filteredPayees[indexPath.row]
        filteredPayees.removeAll()
        addExpenseView.suggestionsTableView.isHidden = true
        addExpenseView.updateSuggestionsHeight(0)
        addPayee(user)
        addExpenseView.suggestionsTableView.reloadData()
    }
}
