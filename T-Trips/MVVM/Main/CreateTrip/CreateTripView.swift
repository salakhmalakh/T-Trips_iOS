import UIKit
import SnapKit

final class CreateTripView: UIView {
    private let textFieldFactory = TextFieldFactory()
    private let buttonFactory = ButtonFactory()

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
    public private(set) lazy var startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 14.0, *) { picker.preferredDatePickerStyle = .wheels }
        return picker
    }()
    public private(set) lazy var endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 14.0, *) { picker.preferredDatePickerStyle = .wheels }
        return picker
    }()

    private lazy var accessoryToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endEditingNow))
        toolbar.setItems([flex, done], animated: false)
        return toolbar
    }()

    public private(set) lazy var titleTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.titlePlaceholder, state: .name)
        let tf = textFieldFactory.makeTextField(with: model)
        tf.inputAccessoryView = accessoryToolbar
        return tf
    }()

    public private(set) lazy var startDateTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.startDatePlaceholder, state: .picker)
        let tf = textFieldFactory.makeTextField(with: model)
        tf.inputView = startDatePicker
        tf.inputAccessoryView = accessoryToolbar
        return tf
    }()

    public private(set) lazy var endDateTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.endDatePlaceholder, state: .picker)
        let tf = textFieldFactory.makeTextField(with: model)
        tf.inputView = endDatePicker
        tf.inputAccessoryView = accessoryToolbar
        return tf
    }()

    public private(set) lazy var budgetTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.budgetPlaceholder, state: .money)
        let tf = textFieldFactory.makeTextField(with: model)
        tf.keyboardType = .decimalPad
        tf.inputAccessoryView = accessoryToolbar
        return tf
    }()

    public private(set) lazy var participantsTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.participantsPlaceholder, state: .name)
        let tf = textFieldFactory.makeTextField(with: model)
        tf.inputAccessoryView = accessoryToolbar
        return tf
    }()

    public private(set) lazy var descriptionTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.descriptionPlaceholder, state: .name)
        let tf = textFieldFactory.makeTextField(with: model)
        tf.inputAccessoryView = accessoryToolbar
        return tf
    }()

    public private(set) lazy var saveButton: CustomButton = {
        let button = CustomButton()
        let model = buttonFactory.makeConfiguration(title: String.saveButtonTitle, state: .primary, isEnabled: false) { }
        button.configure(with: model)
        return button
    }()

     override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        [titleTextField, startDateTextField, endDateTextField, budgetTextField,
        participantsTextField, tokensView, suggestionsTableView, descriptionTextField, saveButton].forEach(addSubview)
        tokensView.trailingSpace = CGFloat.inputSpace
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground
        [titleTextField, startDateTextField, endDateTextField, budgetTextField,
        participantsTextField, tokensView, suggestionsTableView, descriptionTextField, saveButton].forEach(addSubview)
        tokensView.trailingSpace = CGFloat.inputSpace
        setupConstraints()
    }

    private func setupConstraints() {
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(CGFloat.topInset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
            make.height.equalTo(CGFloat.fieldHeight)
        }
        startDateTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(CGFloat.verticalSpacing)
            make.leading.trailing.height.equalTo(titleTextField)
        }
        endDateTextField.snp.makeConstraints { make in
            make.top.equalTo(startDateTextField.snp.bottom).offset(CGFloat.verticalSpacing)
            make.leading.trailing.height.equalTo(titleTextField)
        }
        budgetTextField.snp.makeConstraints { make in
            make.top.equalTo(endDateTextField.snp.bottom).offset(CGFloat.verticalSpacing)
            make.leading.trailing.height.equalTo(titleTextField)
        }
        participantsTextField.snp.makeConstraints { make in
            make.top.equalTo(budgetTextField.snp.bottom).offset(CGFloat.verticalSpacing)
            make.leading.trailing.equalTo(titleTextField)
            make.height.equalTo(CGFloat.fieldHeight)
        }
        tokensView.snp.makeConstraints { make in
            make.top.equalTo(participantsTextField.snp.bottom).offset(CGFloat.tokenTop)
            make.leading.trailing.equalTo(participantsTextField).inset(CGFloat.tokenInset)
        }
        suggestionsTableView.snp.makeConstraints { make in
            make.top.equalTo(participantsTextField.snp.bottom)
            make.leading.trailing.equalTo(participantsTextField)
            suggestionsHeightConstraint = make.height.equalTo(0).constraint
        }
        suggestionsTableView.snp.makeConstraints { make in
            make.top.equalTo(participantsTextField.snp.bottom)
            make.leading.trailing.equalTo(participantsTextField)
            suggestionsHeightConstraint = make.height.equalTo(0).constraint
        }
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(tokensView.snp.bottom).offset(CGFloat.verticalSpacing)
            make.leading.trailing.height.equalTo(titleTextField)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(CGFloat.buttonTop)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
            make.height.equalTo(CGFloat.buttonHeight)
        }
    }

    func updateSuggestionsHeight(_ height: CGFloat) {
        suggestionsHeightConstraint?.update(offset: height)
        layoutIfNeeded()
    }

    func updateSuggestionsHeight(_ height: CGFloat) {
        suggestionsHeightConstraint?.update(offset: height)
        layoutIfNeeded()
    }

    @objc private func endEditingNow() {
        endEditing(true)
    }
}

private extension CGFloat {
    static let topInset: CGFloat = 24
    static let horizontalInset: CGFloat = 20
    static let verticalSpacing: CGFloat = 16
    static let fieldHeight: CGFloat = 50
    static let buttonTop: CGFloat = 24
    static let buttonHeight: CGFloat = 50
    static let tokenSpacing: CGFloat = 4
    static let tokenInset: CGFloat = 4
    static let inputSpace: CGFloat = 60
    static let tokenTop: CGFloat = 4
}

private extension String {
    static let titlePlaceholder = "Название"
    static let startDatePlaceholder = "Дата начала"
    static let endDatePlaceholder = "Дата конца"
    static let budgetPlaceholder = "Бюджет"
    static let participantsPlaceholder = "Участники"
    static let descriptionPlaceholder = "Описание"
    static let saveButtonTitle = "Сохранить"
}
