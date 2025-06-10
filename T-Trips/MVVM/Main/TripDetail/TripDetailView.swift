import UIKit
import SnapKit

final class TripDetailView: UIView {
    // MARK: - UI Components
    let headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: CGFloat.headerFontSize, weight: .bold)
        lbl.textAlignment = .left
        lbl.text = "tripDetailsTitle".localized
        return lbl
    }()

    let titleLabel = UILabel()
    let startLabel = UILabel()
    let endLabel = UILabel()
    private lazy var datesStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startLabel, endLabel])
        stack.axis = .horizontal
        stack.spacing = CGFloat.datesSpacing
        stack.distribution = .fillEqually
        return stack
    }()
    let budgetLabel = UILabel()

    let participantsTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "participantsTitle".localized
        return lbl
    }()

    let participantsLabel = UILabel()

    let descriptionTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "tripDescriptionTitle".localized
        return lbl
    }()

    let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        [headerLabel, titleLabel, datesStackView, budgetLabel,
         participantsTitleLabel, participantsLabel,
         descriptionTitleLabel, descriptionLabel].forEach(addSubview)

        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground

        [headerLabel, titleLabel, datesStackView, budgetLabel,
         participantsTitleLabel, participantsLabel,
         descriptionTitleLabel, descriptionLabel].forEach(addSubview)

        setupUI()
        setupConstraints()
    }

    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(CGFloat.topInset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(CGFloat.sectionSpacing)
            make.leading.trailing.equalTo(headerLabel)
        }
        datesStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.sectionSpacing)
            make.leading.trailing.equalTo(titleLabel)
        }
        budgetLabel.snp.makeConstraints { make in
            make.top.equalTo(datesStackView.snp.bottom).offset(CGFloat.sectionSpacing)
            make.leading.trailing.equalTo(titleLabel)
        }
        participantsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(budgetLabel.snp.bottom).offset(CGFloat.sectionSpacing)
            make.leading.trailing.equalTo(titleLabel)
        }
        participantsLabel.snp.makeConstraints { make in
            make.top.equalTo(participantsTitleLabel.snp.bottom).offset(CGFloat.rowSpacing)
            make.leading.trailing.equalTo(titleLabel)
        }
        descriptionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(participantsLabel.snp.bottom).offset(CGFloat.sectionSpacing)
            make.leading.trailing.equalTo(titleLabel)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitleLabel.snp.bottom).offset(CGFloat.rowSpacing)
            make.leading.trailing.equalTo(titleLabel)
        }
    }

    private func setupUI() {
        backgroundColor = .systemBackground

        headerLabel.numberOfLines = 0

        titleLabel.font = .systemFont(ofSize: CGFloat.titleFontSize, weight: .bold)
        titleLabel.numberOfLines = 0

        startLabel.font = .systemFont(ofSize: CGFloat.infoFontSize, weight: .regular)
        startLabel.numberOfLines = 0

        endLabel.font = .systemFont(ofSize: CGFloat.infoFontSize, weight: .regular)
        endLabel.numberOfLines = 0

        budgetLabel.font = .systemFont(ofSize: CGFloat.budgetFontSize, weight: .bold)
        budgetLabel.numberOfLines = 0

        participantsTitleLabel.font = .systemFont(ofSize: CGFloat.smallTitleFontSize, weight: .regular)
        participantsTitleLabel.textColor = UIColor.label.withAlphaComponent(CGFloat.titleAlpha)

        participantsLabel.font = .systemFont(ofSize: CGFloat.detailFontSize, weight: .regular)
        participantsLabel.numberOfLines = 0

        descriptionTitleLabel.font = .systemFont(ofSize: CGFloat.smallTitleFontSize, weight: .regular)
        descriptionTitleLabel.textColor = UIColor.label.withAlphaComponent(CGFloat.titleAlpha)

        descriptionLabel.font = .systemFont(ofSize: CGFloat.detailFontSize, weight: .regular)
        descriptionLabel.numberOfLines = 0
    }

}

private extension CGFloat {
    static let topInset: CGFloat = 24
    static let horizontalInset: CGFloat = 16
    static let sectionSpacing: CGFloat = 16
    static let rowSpacing: CGFloat = 8
    static let titleFontSize: CGFloat = 22
    static let infoFontSize: CGFloat = 16
    static let budgetFontSize: CGFloat = 18
    static let detailFontSize: CGFloat = 14
    static let smallTitleFontSize: CGFloat = 12
    static let titleAlpha: CGFloat = 0.6
    static let datesSpacing: CGFloat = 8
    static let headerFontSize: CGFloat = 28
}
