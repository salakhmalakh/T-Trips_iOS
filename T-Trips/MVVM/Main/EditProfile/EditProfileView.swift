import UIKit
import SnapKit

final class EditProfileView: UIView {
    private let textFieldFactory = TextFieldFactory()
    private let buttonFactory = ButtonFactory()

    public private(set) lazy var firstNameTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.firstNamePlaceholder, state: .name)
        return textFieldFactory.makeTextField(with: model)
    }()

    public private(set) lazy var lastNameTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.lastNamePlaceholder, state: .name)
        return textFieldFactory.makeTextField(with: model)
    }()

    public private(set) lazy var phoneTextField: CustomTextField = {
        let model = TextFieldModel(placeholder: String.phonePlaceholder, state: .phoneNumber)
        return textFieldFactory.makeTextField(with: model)
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
        [firstNameTextField, lastNameTextField, phoneTextField, saveButton].forEach(addSubview)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground
        [firstNameTextField, lastNameTextField, phoneTextField, saveButton].forEach(addSubview)
        setupConstraints()
    }

    private func setupConstraints() {
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(CGFloat.topInset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
            make.height.equalTo(CGFloat.fieldHeight)
        }
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(CGFloat.verticalSpacing)
            make.leading.trailing.height.equalTo(firstNameTextField)
        }
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(CGFloat.verticalSpacing)
            make.leading.trailing.height.equalTo(firstNameTextField)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(CGFloat.buttonTopOffset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
            make.height.equalTo(CGFloat.buttonHeight)
        }
    }
}

private extension CGFloat {
    static let topInset: CGFloat = 24
    static let horizontalInset: CGFloat = 20
    static let fieldHeight: CGFloat = 50
    static let verticalSpacing: CGFloat = 16
    static let buttonTopOffset: CGFloat = 24
    static let buttonHeight: CGFloat = 50
}

private extension String {
    static var firstNamePlaceholder: String { "firstName".localized }
    static var lastNamePlaceholder: String { "lastName".localized }
    static var phonePlaceholder: String { "phone".localized }
    static var saveButtonTitle: String { "saveButtonTitle".localized }
}
