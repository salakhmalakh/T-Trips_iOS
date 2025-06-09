//
//  AddExpenseView.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 26.05.2025.
//

import UIKit
import SnapKit

final class AddExpenseView: UIView {
    // MARK: - Factories
    private let textFieldFactory = TextFieldFactory()
    
    // MARK: - Pickers & Input Views
    let categoryPicker = UIPickerView()
    let payerPicker = UIPickerView()
    let suggestionsTableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.layer.borderWidth = 0.5
        table.layer.borderColor = UIColor.lightGray.cgColor
        return table
    }()
    public private(set) lazy var tokensView: TokenWrappingView = {
        let view = TokenWrappingView()
        view.spacing = CGFloat.tokenSpacing
        view.onHeightChange = { [weak self] in
            self?.setNeedsLayout()
            self?.layoutIfNeeded()
        }
        return view
    }()
    private var suggestionsHeightConstraint: Constraint?
    public private(set) lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 14.0, *) { picker.preferredDatePickerStyle = .inline }
        return picker
    }()
    
    private lazy var accessoryToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissInput))
        toolbar.setItems([flex, done], animated: false)
        return toolbar
    }()
    
    // MARK: - UI Components
    public private(set) lazy var amountTextField: CustomTextField = {
        let model = TextFieldModel(
            placeholder: String.addExpenseAmountPlaceholder,
            state: .money
        )
        let textfield = textFieldFactory.makeTextField(with: model)
        textfield.keyboardType = .decimalPad
        textfield.inputAccessoryView = accessoryToolbar
        return textfield
    }()

    public private(set) lazy var titleTextField: CustomTextField = {
        let model = TextFieldModel(
            placeholder: String.addExpenseTitlePlaceholder,
            state: .name
        )
        let textfield = textFieldFactory.makeTextField(with: model)
        textfield.inputAccessoryView = accessoryToolbar
        return textfield
    }()
    
    public private(set) lazy var dateTextField: CustomTextField = {
        let model = TextFieldModel(
            placeholder: String.addExpenseDatePlaceholder,
            state: .picker
        )
        let textfield = textFieldFactory.makeTextField(with: model)
        textfield.inputView = datePicker
        textfield.inputAccessoryView = accessoryToolbar
        return textfield
    }()
    
    public private(set) lazy var categoryTextField: CustomTextField = {
        let model = TextFieldModel(
            placeholder: String.addExpenseCategoryPlaceholder,
            state: .picker
        )
        let textfield = textFieldFactory.makeTextField(with: model)
        textfield.inputView = categoryPicker
        textfield.inputAccessoryView = accessoryToolbar
        return textfield
    }()
    
    public private(set) lazy var payerTextField: CustomTextField = {
        let model = TextFieldModel(
            placeholder: String.addExpensePayerPlaceholder,
            state: .name
        )
        let textfield = textFieldFactory.makeTextField(with: model)
        textfield.inputView = payerPicker
        textfield.inputAccessoryView = accessoryToolbar
        return textfield
    }()
    
    public private(set) lazy var payeeTextField: CustomTextField = {
        let model = TextFieldModel(
            placeholder: String.addExpensePayeePlaceholder,
            state: .name
        )
        let textfield = textFieldFactory.makeTextField(with: model)
        textfield.inputAccessoryView = accessoryToolbar
        return textfield
    }()
    
    public private(set) lazy var addButton: CustomButton = {
        let button = CustomButton()
        let model = ButtonModel(
            title: String.addExpenseButtonTitle,
            state: .primary,
            isEnabled: false,
            action: nil
        )
        button.configure(with: model)
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        [
            titleTextField,
            amountTextField,
            dateTextField,
            categoryTextField,
            payerTextField,
            payeeTextField,
            tokensView,
            suggestionsTableView,
            addButton
        ].forEach(addSubview)
        tokensView.trailingSpace = CGFloat.inputSpace
        setupConstraints()
        configurePickers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground
        [
            titleTextField,
            amountTextField,
            dateTextField,
            categoryTextField,
            payerTextField,
            payeeTextField,
            tokensView,
            suggestionsTableView,
            addButton
        ].forEach(addSubview)
        tokensView.trailingSpace = CGFloat.inputSpace
        setupConstraints()
        configurePickers()
    }
    
    private func setupConstraints() {
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(CGFloat.topInset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
            make.height.equalTo(CGFloat.fieldHeight)
        }
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(CGFloat.verticalSpacing)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
            make.height.equalTo(CGFloat.fieldHeight)
        }
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(CGFloat.verticalSpacing)
            make.leading.trailing.height.equalTo(amountTextField)
        }
        categoryTextField.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(CGFloat.verticalSpacing)
            make.leading.trailing.height.equalTo(amountTextField)
        }
        payerTextField.snp.makeConstraints { make in
            make.top.equalTo(categoryTextField.snp.bottom).offset(CGFloat.verticalSpacing)
            make.leading.trailing.height.equalTo(amountTextField)
        }
        payeeTextField.snp.makeConstraints { make in
            make.top.equalTo(payerTextField.snp.bottom).offset(CGFloat.verticalSpacing)
            make.leading.trailing.equalTo(amountTextField)
            make.height.equalTo(CGFloat.fieldHeight)
        }
        tokensView.snp.makeConstraints { make in
            make.top.equalTo(payeeTextField.snp.bottom).offset(CGFloat.tokenTop)
            make.leading.trailing.equalTo(payeeTextField).inset(CGFloat.tokenInset)
        }
        suggestionsTableView.snp.makeConstraints { make in
            make.top.equalTo(payeeTextField.snp.bottom)
            make.leading.trailing.equalTo(payeeTextField)
            suggestionsHeightConstraint = make.height.equalTo(0).constraint
        }
        addButton.snp.makeConstraints { make in
            make.top.equalTo(tokensView.snp.bottom).offset(CGFloat.buttonTopOffset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
            make.height.equalTo(CGFloat.buttonHeight)
        }
    }
    
    private func configurePickers() {
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) { datePicker.preferredDatePickerStyle = .wheels }
    }

    func updateSuggestionsHeight(_ height: CGFloat) {
        suggestionsHeightConstraint?.update(offset: height)
        layoutIfNeeded()
    }
    
    @objc private func dismissInput() {
        endEditing(true)
    }
}

// MARK: - Constants
private extension CGFloat {
    static let topInset: CGFloat = 24
    static let horizontalInset: CGFloat = 20
    static let fieldHeight: CGFloat = 50
    static let verticalSpacing: CGFloat = 16
    static let buttonTopOffset: CGFloat = 24
    static let buttonHeight: CGFloat = 50
    static let pickerRowHeight: CGFloat = 44
    static let tokenSpacing: CGFloat = 4
    static let tokenInset: CGFloat = 4
    static let inputSpace: CGFloat = 60
    static let tokenTop: CGFloat = 4
}

private extension String {
    static var addExpenseTitlePlaceholder: String { "addExpenseTitlePlaceholder".localized }
    static var addExpenseAmountPlaceholder: String { "addExpenseAmountPlaceholder".localized }
    static var addExpenseCategoryPlaceholder: String { "addExpenseCategoryPlaceholder".localized }
    static var addExpenseDatePlaceholder: String { "addExpenseDatePlaceholder".localized }
    static var addExpensePayerPlaceholder: String { "addExpensePayerPlaceholder".localized }
    static var addExpensePayeePlaceholder: String { "addExpensePayeePlaceholder".localized }
    static var addExpenseButtonTitle: String { "addExpenseButtonTitle".localized }
}
