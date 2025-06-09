import UIKit
import SnapKit

final class ParticipantTokenView: UIView {
    private let nameLabel = UILabel()
    private let removeButton = UIButton(type: .system)
    var onRemove: (() -> Void)?

    init(name: String) {
        super.init(frame: .zero)
        nameLabel.text = name
        nameLabel.font = UIFont.systemFont(ofSize: CGFloat.nameFontSize)
        removeButton.setTitle("\u{2715}", for: .normal)
        removeButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat.nameFontSize, weight: .bold)
        removeButton.addAction(UIAction { [weak self] _ in
            self?.onRemove?()
        }, for: .touchUpInside)

        backgroundColor = .systemGray5
        layer.cornerRadius = CGFloat.cornerRadius
        layer.masksToBounds = true

        addSubview(nameLabel)
        addSubview(removeButton)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let local = convert(point, to: removeButton)
        return removeButton.point(inside: local, with: event)
    }
  
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(CGFloat.contentInset)
        }
        removeButton.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(CGFloat.spacing)
            make.trailing.equalToSuperview().inset(CGFloat.contentInset)
            make.centerY.equalToSuperview()
        }
    }
}

private extension CGFloat {
    static let contentInset: CGFloat = 4
    static let spacing: CGFloat = 4
    static let nameFontSize: CGFloat = 12
    static let cornerRadius: CGFloat = 4
}
