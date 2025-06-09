import Foundation

final class NotificationsViewModel {
    var notifications: [NotificationItem] = []

    init() {
        load()
    }

    private func load() {
        MockAPIService.shared.getNotifications { [weak self] items in
            DispatchQueue.main.async {
                self?.notifications = items
            }
        }
    }
}
