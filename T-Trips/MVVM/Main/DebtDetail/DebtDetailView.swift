import UIKit
import SnapKit

final class DebtDetailView: UIView {
    let creditorLabel = UILabel()
    let amountLabel = UILabel()
    let requisitesTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = String.requisitesTitle
        lbl.font = .systemFont(ofSize: CGFloat.titleFont, weight: .regular)
        lbl.textColor = UIColor.label.withAlphaComponent(CGFloat.titleAlpha)
        return lbl
    }()
    let requisitesLabel = UILabel()
    let tripTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = String.tripNameTitle
        lbl.font = .systemFont(ofSize: CGFloat.titleFont, weight: .regular)
        lbl.textColor = UIColor.label.withAlphaComponent(CGFloat.titleAlpha)
        return lbl
    }()
    let tripLabel = UILabel()
    let payButton: CustomButton = {
        let button = CustomButton()
        let model = ButtonFactory().makeConfiguration(title: "payButtonTitle".localized, state: .primary, isEnabled: true) { }
        button.configure(with: model)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        [creditorLabel, amountLabel, requisitesTitleLabel, requisitesLabel, tripTitleLabel, tripLabel, payButton].forEach(addSubview)
        creditorLabel.numberOfLines = 0
        creditorLabel.font = .systemFont(ofSize: CGFloat.creditorFont, weight: .medium)
        amountLabel.font = .systemFont(ofSize: CGFloat.amountFont, weight: .bold)
        amountLabel.textColor = .amountColor
        requisitesLabel.font = .systemFont(ofSize: CGFloat.infoFont, weight: .regular)
        requisitesLabel.numberOfLines = 0
        tripLabel.font = .systemFont(ofSize: CGFloat.infoFont, weight: .regular)
        tripLabel.numberOfLines = 0
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground
        [creditorLabel, amountLabel, requisitesTitleLabel, requisitesLabel, tripTitleLabel, tripLabel, payButton].forEach(addSubview)
        creditorLabel.numberOfLines = 0
        creditorLabel.font = .systemFont(ofSize: CGFloat.creditorFont, weight: .medium)
        amountLabel.font = .systemFont(ofSize: CGFloat.amountFont, weight: .bold)
        amountLabel.textColor = .amountColor
        requisitesLabel.font = .systemFont(ofSize: CGFloat.infoFont, weight: .regular)
        requisitesLabel.numberOfLines = 0
        tripLabel.font = .systemFont(ofSize: CGFloat.infoFont, weight: .regular)
        tripLabel.numberOfLines = 0
        setupConstraints()
    }

    private func setupConstraints() {
        creditorLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(CGFloat.topInset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
        }
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(creditorLabel.snp.bottom).offset(CGFloat.spacing)
            make.leading.trailing.equalTo(creditorLabel)
        }
        requisitesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(CGFloat.sectionSpacing)
            make.leading.trailing.equalTo(creditorLabel)
        }
        requisitesLabel.snp.makeConstraints { make in
            make.top.equalTo(requisitesTitleLabel.snp.bottom).offset(CGFloat.spacing)
            make.leading.trailing.equalTo(creditorLabel)
        }
        tripTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(requisitesLabel.snp.bottom).offset(CGFloat.sectionSpacing)
            make.leading.trailing.equalTo(creditorLabel)
        }
        tripLabel.snp.makeConstraints { make in
            make.top.equalTo(tripTitleLabel.snp.bottom).offset(CGFloat.spacing)
            make.leading.trailing.equalTo(creditorLabel)
        }
        payButton.snp.makeConstraints { make in
            make.top.equalTo(tripLabel.snp.bottom).offset(CGFloat.buttonTop)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
            make.height.equalTo(CGFloat.buttonHeight)
        }
    }
}

private extension CGFloat {
    static let topInset: CGFloat = 24
    static let horizontalInset: CGFloat = 20
    static let sectionSpacing: CGFloat = 16
    static let spacing: CGFloat = 8
    static let buttonTop: CGFloat = 24
    static let buttonHeight: CGFloat = 50
    static let creditorFont: CGFloat = 20
    static let amountFont: CGFloat = 28
    static let infoFont: CGFloat = 16
    static let titleFont: CGFloat = 12
    static let titleAlpha: CGFloat = 0.6
}

private extension UIColor {
    static let amountColor = UIColor.systemBlue
}

private extension String {
    static var requisitesTitle: String { "requisitesTitle".localized }
    static var tripNameTitle: String { "tripNameTitle".localized }
}
