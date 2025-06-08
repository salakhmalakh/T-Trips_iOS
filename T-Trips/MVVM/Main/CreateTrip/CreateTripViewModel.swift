import Foundation
import Combine

final class CreateTripViewModel {
    @Published var title: String = ""
    @Published var budget: String = ""
    @Published var description: String = ""
    @Published var participantIds: [Int64] = []
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()

    @Published private(set) var isSaveEnabled = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        Publishers.CombineLatest4($title, $budget, $description, $participantIds)
            .combineLatest(Publishers.CombineLatest($startDate, $endDate))
            .map { combined, dates in
                let (title, budget, description, participants) = combined
                let (start, end) = dates
                return !title.isEmpty && Double(budget) != nil && !description.isEmpty && !participants.isEmpty && start <= end
            }
            .receive(on: RunLoop.main)
            .assign(to: \ .isSaveEnabled, on: self)
            .store(in: &cancellables)
    }

    func saveTrip() {
        // TODO: Send data to backend
    }
}
