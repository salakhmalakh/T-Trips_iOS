import UIKit
import SnapKit

final class DebtDetailView: UIView {
    let participantsLabel = UILabel()
    let amountLabel = UILabel()
    let payButton: CustomButton = {
        let button = CustomButton()
        let model = ButtonFactory().makeConfiguration(title: "payButtonTitle".localized, state: .primary, isEnabled: true) { }
        button.configure(with: model)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        [participantsLabel, amountLabel, payButton].forEach(addSubview)
        participantsLabel.numberOfLines = 0
        participantsLabel.font = .systemFont(ofSize: CGFloat.participantsFont, weight: .medium)
        amountLabel.font = .systemFont(ofSize: CGFloat.amountFont, weight: .bold)
        amountLabel.textColor = .amountColor
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground
        [participantsLabel, amountLabel, payButton].forEach(addSubview)
        participantsLabel.numberOfLines = 0
        participantsLabel.font = .systemFont(ofSize: CGFloat.participantsFont, weight: .medium)
        amountLabel.font = .systemFont(ofSize: CGFloat.amountFont, weight: .bold)
        amountLabel.textColor = .amountColor
        setupConstraints()
    }

    private func setupConstraints() {
        participantsLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(CGFloat.topInset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
        }
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(participantsLabel.snp.bottom).offset(CGFloat.spacing)
            make.leading.trailing.equalTo(participantsLabel)
        }
        payButton.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(CGFloat.buttonTop)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
            make.height.equalTo(CGFloat.buttonHeight)
        }
    }
}

private extension CGFloat {
    static let topInset: CGFloat = 24
    static let horizontalInset: CGFloat = 20
    static let spacing: CGFloat = 8
    static let buttonTop: CGFloat = 24
    static let buttonHeight: CGFloat = 50
    static let participantsFont: CGFloat = 20
    static let amountFont: CGFloat = 28
}

private extension UIColor {
    static let amountColor = UIColor.systemBlue
}
