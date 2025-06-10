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

    func respond(to item: NotificationItem, accept: Bool, completion: @escaping () -> Void) {
        MockAPIService.shared.respondToInvitation(notificationId: item.id, accept: accept) { [weak self] in
            DispatchQueue.main.async {
                if let index = self?.notifications.firstIndex(where: { $0.id == item.id }) {
                    self?.notifications.remove(at: index)
                }
                completion()
            }
        }
    }
}
