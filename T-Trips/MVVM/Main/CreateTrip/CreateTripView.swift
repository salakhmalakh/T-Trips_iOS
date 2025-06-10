import UIKit
import SnapKit

final class CreateTripView: UIView {
    private let textFieldFactory = TextFieldFactory()
    private let buttonFactory = ButtonFactory()

    let headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: CGFloat.headerFontSize, weight: .bold)
        lbl.textAlignment = .left
        lbl.text = "createTripTitle".localized
        return lbl
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
        let model = TextFieldModel(placeholder: String.titlePlaceholder, state: .title)
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

    private lazy var datesStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startDateTextField, endDateTextField])
        stack.axis = .horizontal
        stack.spacing = CGFloat.datesSpacing
        stack.distribution = .fillEqually
        return stack
    }()

    public private(set) lazy var budgetTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.budgetPlaceholder, state: .money)
        let tf = textFieldFactory.makeTextField(with: model)
        tf.keyboardType = .decimalPad
        tf.inputAccessoryView = accessoryToolbar
        return tf
    }()

    public private(set) lazy var participantsTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.participantsPlaceholder, state: .phoneNumber)
        let tf = textFieldFactory.makeTextField(with: model)
        tf.inputAccessoryView = accessoryToolbar
        return tf
    }()

    public private(set) lazy var descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: CGFloat.descriptionFontSize)
        tv.layer.borderWidth = CGFloat.borderWidth
        tv.layer.borderColor = UIColor.borderColor.cgColor
        tv.layer.cornerRadius = CGFloat.cornerRadius
        tv.backgroundColor = .appBackground
        tv.textContainerInset = UIEdgeInsets.textViewPadding
        tv.isScrollEnabled = true
        tv.inputAccessoryView = accessoryToolbar
        return tv
    }()

    public private(set) lazy var saveButton: CustomButton = {
        let button = CustomButton()
        let model = buttonFactory.makeConfiguration(title: String.saveButtonTitle, state: .primary, isEnabled: false) { }
        button.configure(with: model)
        return button
    }()

     override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appBackground
        [headerLabel, titleTextField, datesStackView, budgetTextField,
        participantsTextField, tokensView, descriptionTextView, saveButton].forEach(addSubview)
        tokensView.trailingSpace = CGFloat.inputSpace
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .appBackground
        [headerLabel, titleTextField, datesStackView, budgetTextField,
        participantsTextField, tokensView, descriptionTextView, saveButton].forEach(addSubview)
        tokensView.trailingSpace = CGFloat.inputSpace
        setupConstraints()
    }

    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(CGFloat.topInset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
        }
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(CGFloat.verticalSpacing)
            make.leading.trailing.equalTo(headerLabel)
            make.height.equalTo(CGFloat.fieldHeight)
        }
        datesStackView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(CGFloat.verticalSpacing)
            make.leading.trailing.equalTo(titleTextField)
            make.height.equalTo(CGFloat.fieldHeight)
        }
        [startDateTextField, endDateTextField].forEach { field in
            field.snp.makeConstraints { make in
                make.height.equalTo(CGFloat.fieldHeight)
            }
        }
        budgetTextField.snp.makeConstraints { make in
            make.top.equalTo(datesStackView.snp.bottom).offset(CGFloat.verticalSpacing)
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
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(tokensView.snp.bottom).offset(CGFloat.verticalSpacing)
            make.leading.trailing.equalTo(titleTextField)
            make.height.equalTo(CGFloat.descriptionHeight)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(CGFloat.buttonTop)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
            make.height.equalTo(CGFloat.buttonHeight)
        }
    }

    @objc private func endEditingNow() {
        endEditing(true)
    }
}

private extension CGFloat {
    static let topInset: CGFloat = 24
    static let headerFontSize: CGFloat = 28
    static let horizontalInset: CGFloat = 20
    static let verticalSpacing: CGFloat = 16
    static let fieldHeight: CGFloat = 50
    static let buttonTop: CGFloat = 24
    static let buttonHeight: CGFloat = 50
    static let tokenSpacing: CGFloat = 4
    static let tokenInset: CGFloat = 4
    static let inputSpace: CGFloat = 60
    static let tokenTop: CGFloat = 4
    static let datesSpacing: CGFloat = 8
    static let descriptionHeight: CGFloat = fieldHeight * 2
    static let descriptionFontSize: CGFloat = 16
    static let borderWidth: CGFloat = 0.5
    static let cornerRadius: CGFloat = 12
}

private extension String {
    static var titlePlaceholder: String { "titlePlaceholder".localized }
    static var startDatePlaceholder: String { "startDatePlaceholder".localized }
    static var endDatePlaceholder: String { "endDatePlaceholder".localized }
    static var budgetPlaceholder: String { "budgetPlaceholder".localized }
    static var participantsPlaceholder: String { "participantsPlaceholder".localized }
    static var descriptionPlaceholder: String { "descriptionPlaceholder".localized }
    static var saveButtonTitle: String { "saveButtonTitle".localized }
}

private extension UIColor {
    static let borderColor = UIColor.lightGray
}

private extension UIEdgeInsets {
    static let textViewPadding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
}
