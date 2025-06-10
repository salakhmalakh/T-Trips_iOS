import UIKit
import SnapKit

final class InvitationCell: UITableViewCell {
    static let reuseId = "InvitationCell"

    private let messageLabel = UILabel()
    private let acceptButton = CustomButton()
    private let rejectButton = CustomButton()

    var onAccept: (() -> Void)?
    var onReject: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = CGFloat.cornerRadius
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.shadowColor
        layer.shadowOpacity = Float.shadowOpacity
        layer.shadowOffset = CGSize.shadowOffset
        layer.shadowRadius = CGFloat.shadowRadius
        layer.masksToBounds = false

        [messageLabel, acceptButton, rejectButton].forEach { contentView.addSubview($0) }

        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: CGFloat.fontSize)

        let acceptModel = ButtonModel(title: String.accept, state: .primary, isEnabled: true) { [weak self] in
            self?.onAccept?()
        }
        acceptButton.configure(with: acceptModel)

        let rejectModel = ButtonModel(title: String.reject, state: .secondary, isEnabled: true) { [weak self] in
            self?.onReject?()
        }
        rejectButton.configure(with: rejectModel)

        messageLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(CGFloat.sideInset)
        }
        acceptButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(CGFloat.buttonSpacing)
            make.leading.equalToSuperview().offset(CGFloat.sideInset)
            make.bottom.equalToSuperview().inset(CGFloat.sideInset)
        }
        rejectButton.snp.makeConstraints { make in
            make.top.equalTo(acceptButton)
            make.leading.equalTo(acceptButton.snp.trailing).offset(CGFloat.buttonSpacing)
            make.trailing.equalToSuperview().inset(CGFloat.sideInset)
            make.width.equalTo(acceptButton)
            make.bottom.equalTo(acceptButton)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets.contentInset)
        layer.shadowPath = UIBezierPath(roundedRect: contentView.frame, cornerRadius: contentView.layer.cornerRadius).cgPath
    }

    func configure(message: String) {
        messageLabel.text = message
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 12
    static let shadowRadius: CGFloat = 4
    static let sideInset: CGFloat = 16
    static let buttonSpacing: CGFloat = 12
    static let fontSize: CGFloat = 16
}

private extension Float {
    static let shadowOpacity: Float = 0.1
}

private extension CGSize {
    static let shadowOffset = CGSize(width: 0, height: 2)
}

private extension UIEdgeInsets {
    static let contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
}

private extension UIColor {
    static let shadowColor = UIColor.black.cgColor
}

private extension String {
    static var accept: String { "acceptButtonTitle".localized }
    static var reject: String { "rejectButtonTitle".localized }
}
