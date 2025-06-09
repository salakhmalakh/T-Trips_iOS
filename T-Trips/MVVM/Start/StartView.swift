import UIKit
import SnapKit

final class StartView: UIView {
    let logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage.tLogo)
        view.contentMode = .scaleAspectFit
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .primaryColor
        addSubview(logoImageView)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .primaryColor
        addSubview(logoImageView)
        setupConstraints()
    }

    private func setupConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-CGFloat.imageOffset)
            make.width.height.equalTo(CGFloat.logoSize)
        }
    }
}

private extension CGFloat {
    static let logoSize: CGFloat = 120
    static let imageOffset: CGFloat = 40
}

private extension UIImage {
    static let tLogo = UIImage(named: "whiteShieldT") ?? UIImage()
}

private extension UIColor {
    static let primaryColor = UIColor(named: "primaryButtonColor")
}
