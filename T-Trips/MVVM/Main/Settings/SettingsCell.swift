import UIKit
import SnapKit

final class SettingsCell: UITableViewCell {
    static let reuseId = "SettingsCell"

    private let titleLabel = UILabel()
    private var customAccessoryView: UIView?

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

        contentView.addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: CGFloat.titleFontSize)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(CGFloat.sideInset)
            make.centerY.equalToSuperview()
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

    func configure(text: String, accessoryView: UIView? = nil) {
        titleLabel.text = text

        customAccessoryView?.removeFromSuperview()
        customAccessoryView = accessoryView

        if let view = accessoryView {
            contentView.addSubview(view)
            view.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(CGFloat.sideInset)
                make.centerY.equalToSuperview()
            }
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(CGFloat.sideInset)
                make.trailing.lessThanOrEqualTo(view.snp.leading).offset(-CGFloat.sideInset)
                make.centerY.equalToSuperview()
            }
        } else {
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(CGFloat.sideInset)
                make.trailing.equalToSuperview().inset(CGFloat.sideInset)
                make.centerY.equalToSuperview()
            }
        }
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 12
    static let shadowRadius: CGFloat = 4
    static let sideInset: CGFloat = 16
    static let titleFontSize: CGFloat = 16
}

private extension Float {
    static let shadowOpacity: Float = 0.1
}

private extension CGSize {
    static let shadowOffset = CGSize(width: 0, height: 2)
}

private extension UIColor {
    static let shadowColor = UIColor.black.cgColor
}

private extension UIEdgeInsets {
    static let contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
}
