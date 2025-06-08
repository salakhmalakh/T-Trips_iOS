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
    private let payers: [User]
    private let payees: [User]

    // MARK: - Init
    init(tripId: Int64, payers: [User] = [], payees: [User] = []) {
        self.viewModel = AddExpenseViewModel(tripId: tripId)
        self.payers = payers
        self.payees = payees
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
        title = "Добавить расход"
        setupBindings()
        setupPickers()
        setupActions()
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
        addExpenseView.payeeTextField.addAction(
            UIAction { [weak self] _ in self?.addExpenseView.payeeTextField.becomeFirstResponder() },
            for: .editingDidBegin
        )
        addExpenseView.dateTextField.addAction(
            UIAction { [weak self] _ in self?.addExpenseView.dateTextField.becomeFirstResponder() },
            for: .editingDidBegin
        )

        addExpenseView.categoryPicker.dataSource = self
        addExpenseView.categoryPicker.delegate = self
        addExpenseView.payerPicker.dataSource = self
        addExpenseView.payerPicker.delegate = self
        addExpenseView.payeePicker.dataSource = self
        addExpenseView.payeePicker.delegate = self
        addExpenseView.datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
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
            },
            for: .editingDidEnd
        )

        addExpenseView.payeeTextField.addAction(
            UIAction { [weak self] _ in
                let row = self?.addExpenseView.payeePicker.selectedRow(inComponent: 0) ?? 0
                let user = self?.payees[row]
                self?.viewModel.payeeId = user?.id
                self?.addExpenseView.payeeTextField.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
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
        case addExpenseView.payeePicker:
            return payees.count
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
        case addExpenseView.payeePicker:
            let user = payees[row]
            return "\(user.firstName) \(user.lastName)"
        default: return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // no-op: handled on end editing
    }
}
