import UIKit
import SnapKit

final class DebtDetailView: UIView {
    let infoLabel = UILabel()
    let confirmButton: CustomButton = {
        let button = CustomButton()
        let model = ButtonFactory().makeConfiguration(title: "Подтвердить", state: .primary, isEnabled: true) { }
        button.configure(with: model)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        [infoLabel, confirmButton].forEach(addSubview)
        infoLabel.numberOfLines = 0
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground
        [infoLabel, confirmButton].forEach(addSubview)
        infoLabel.numberOfLines = 0
        setupConstraints()
    }

    private func setupConstraints() {
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(CGFloat.topInset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
        }
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(CGFloat.buttonTop)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
            make.height.equalTo(CGFloat.buttonHeight)
        }
    }
}

private extension CGFloat {
    static let topInset: CGFloat = 24
    static let horizontalInset: CGFloat = 20
    static let buttonTop: CGFloat = 24
    static let buttonHeight: CGFloat = 50
}
