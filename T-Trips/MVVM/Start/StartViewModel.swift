import Foundation

final class StartViewModel {
    var onFinish: (() -> Void)?

    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.onFinish?()
        }
    }
}
