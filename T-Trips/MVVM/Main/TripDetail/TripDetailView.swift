import UIKit
import SnapKit

final class TripDetailView: UIView {
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
        [titleLabel, startLabel, endLabel, budgetLabel,
         participantsTitleLabel, participantsLabel,
         descriptionTitleLabel, descriptionLabel].forEach(addSubview)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground
        [titleLabel, startLabel, endLabel, budgetLabel,
         participantsTitleLabel, participantsLabel,
         descriptionTitleLabel, descriptionLabel].forEach(addSubview)
        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(CGFloat.topInset)
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
}

private extension CGFloat {
    static let topInset: CGFloat = 24
    static let horizontalInset: CGFloat = 16
    static let sectionSpacing: CGFloat = 16
    static let rowSpacing: CGFloat = 8
}
