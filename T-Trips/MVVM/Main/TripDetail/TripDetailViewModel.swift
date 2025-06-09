import Foundation

final class TripDetailViewModel {
    let title: String
    let startText: String
    let endText: String
    let budgetText: String
    let participants: String
    let description: String

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init(trip: Trip, users: [User]) {
        title = trip.title
        startText = formatter.string(from: trip.startDate)
        endText = formatter.string(from: trip.endDate)
        budgetText = trip.budget.rubleString
        let names = users.filter { trip.participantIds?.contains($0.id) ?? false }
            .map { "\($0.firstName) \($0.lastName)" }
        participants = names.joined(separator: ", ")
        description = trip.description ?? ""
    }
}
