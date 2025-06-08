import UIKit
import SnapKit

final class StartView: UIView {
    let logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage.tLogo)
        view.contentMode = .scaleAspectFit
        return view
    }()

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "T-Trips"
        lbl.font = .systemFont(ofSize: CGFloat.titleFontSize, weight: .bold)
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(logoImageView)
        addSubview(titleLabel)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground
        addSubview(logoImageView)
        addSubview(titleLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-CGFloat.imageOffset)
            make.width.height.equalTo(CGFloat.logoSize)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(CGFloat.labelOffset)
            make.centerX.equalToSuperview()
        }
    }
}

private extension CGFloat {
    static let logoSize: CGFloat = 120
    static let titleFontSize: CGFloat = 32
    static let imageOffset: CGFloat = 40
    static let labelOffset: CGFloat = 16
}

private extension UIImage {
    static let tLogo = UIImage(named: "shieldT") ?? UIImage()
}
