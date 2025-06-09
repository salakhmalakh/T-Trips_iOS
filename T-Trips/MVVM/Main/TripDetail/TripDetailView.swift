import UIKit
import SnapKit

final class TripDetailView: UIView {
    // MARK: - UI Components
    private let containerView = UIView()

    let titleLabel = UILabel()
    let startLabel = UILabel()
    let endLabel = UILabel()
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

        addSubview(containerView)
        [titleLabel, startLabel, endLabel, budgetLabel,
         participantsTitleLabel, participantsLabel,
         descriptionTitleLabel, descriptionLabel].forEach(containerView.addSubview)

        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground

        addSubview(containerView)
        [titleLabel, startLabel, endLabel, budgetLabel,
         participantsTitleLabel, participantsLabel,
         descriptionTitleLabel, descriptionLabel].forEach(containerView.addSubview)

        setupUI()
        setupConstraints()
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(UIEdgeInsets.contentInset)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.topInset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.horizontalInset)
        }
        startLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.sectionSpacing)
            make.leading.trailing.equalTo(titleLabel)
        }
        endLabel.snp.makeConstraints { make in
            make.top.equalTo(startLabel.snp.bottom).offset(CGFloat.sectionSpacing)
            make.leading.trailing.equalTo(titleLabel)
        }
        budgetLabel.snp.makeConstraints { make in
            make.top.equalTo(endLabel.snp.bottom).offset(CGFloat.sectionSpacing)
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
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = CGFloat.cornerRadius
        containerView.layer.masksToBounds = true

        layer.shadowColor = UIColor.shadowColor
        layer.shadowOpacity = Float.shadowOpacity
        layer.shadowOffset = .shadowOffset
        layer.shadowRadius = .shadowRadius
        layer.masksToBounds = false

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

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: containerView.frame, cornerRadius: containerView.layer.cornerRadius).cgPath
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
    static let cornerRadius: CGFloat = 12
    static let shadowRadius: CGFloat = 4
    static let titleAlpha: CGFloat = 0.6
}

private extension UIEdgeInsets {
    static let contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
}

private extension CGSize {
    static let shadowOffset = CGSize(width: 0, height: 2)
}

private extension UIColor {
    static let shadowColor = UIColor.black.cgColor
}

private extension Float {
    static let shadowOpacity: Float = 0.1
}
