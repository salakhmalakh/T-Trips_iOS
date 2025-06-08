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
    let payeePicker = UIPickerView()
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
        textfield.inputView = payeePicker
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
            amountTextField,
            dateTextField,
            categoryTextField,
            payerTextField,
            payeeTextField,
            addButton
        ].forEach(addSubview)
        setupConstraints()
        configurePickers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground
        [
            amountTextField,
            dateTextField,
            categoryTextField,
            payerTextField,
            payeeTextField,
            addButton
        ].forEach(addSubview)
        setupConstraints()
        configurePickers()
    }
    
    private func setupConstraints() {
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(CGFloat.topInset)
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
            make.leading.trailing.height.equalTo(amountTextField)
        }
        addButton.snp.makeConstraints { make in
            make.top.equalTo(payeeTextField.snp.bottom).offset(CGFloat.buttonTopOffset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
            make.height.equalTo(CGFloat.buttonHeight)
        }
    }
    
    private func configurePickers() {
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) { datePicker.preferredDatePickerStyle = .wheels }
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
}

private extension String {
    static let addExpenseAmountPlaceholder = "Сумма"
    static let addExpenseCategoryPlaceholder = "Категория"
    static let addExpenseDatePlaceholder = "Дата"
    static let addExpensePayerPlaceholder = "Кто оплатил"
    static let addExpensePayeePlaceholder = "За кого"
    static let addExpenseButtonTitle = "Добавить"
}
