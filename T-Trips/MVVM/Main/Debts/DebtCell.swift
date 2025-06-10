import UIKit
import SnapKit

final class DebtCell: UITableViewCell {
    static let reuseId = "DebtCell"

    private let participantsLabel = UILabel()
    private let amountLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = CGFloat.cornerRadius
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.shadowColor
        layer.shadowOpacity = Float.shadowOpacity
        layer.shadowOffset = .shadowOffset
        layer.shadowRadius = .shadowRadius
        layer.masksToBounds = false

        [participantsLabel, amountLabel].forEach { contentView.addSubview($0) }

        participantsLabel.font = .systemFont(ofSize: CGFloat.participantsFont, weight: .medium)
        participantsLabel.numberOfLines = 0

        amountLabel.font = .systemFont(ofSize: CGFloat.amountFont, weight: .bold)
        amountLabel.textColor = .amountColor

        participantsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.topInset)
            make.leading.trailing.equalToSuperview().inset(CGFloat.sideInset)
        }
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(participantsLabel.snp.bottom).offset(CGFloat.spacing)
            make.leading.trailing.equalTo(participantsLabel)
            make.bottom.equalToSuperview().inset(CGFloat.bottomInset)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets.contentInset)
        layer.shadowPath = UIBezierPath(roundedRect: contentView.frame,
                                        cornerRadius: contentView.layer.cornerRadius).cgPath
    }

    func configure(with debt: Debt, users: [User]) {
        let fromUser = users.first { $0.id == debt.fromUserId }
        let toUser = users.first { $0.id == debt.toUserId }
        let fromName = [fromUser?.firstName, fromUser?.lastName].compactMap { $0 }.joined(separator: " ")
        let toName = [toUser?.firstName, toUser?.lastName].compactMap { $0 }.joined(separator: " ")
        participantsLabel.text = "\(fromName) → \(toName)"
        amountLabel.text = debt.amount.rubleString
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 12
    static let shadowRadius: CGFloat = 4
    static let topInset: CGFloat = 16
    static let bottomInset: CGFloat = 16
    static let sideInset: CGFloat = 16
    static let spacing: CGFloat = 8
    static let participantsFont: CGFloat = 16
    static let amountFont: CGFloat = 18
}

private extension Float {
    static let shadowOpacity: Float = 0.1
}

private extension CGSize {
    static let shadowOffset = CGSize(width: 0, height: 2)
}

private extension UIColor {
    static let shadowColor = UIColor.black.cgColor
    static let amountColor = UIColor.systemBlue
}

private extension UIEdgeInsets {
    static let contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
}
