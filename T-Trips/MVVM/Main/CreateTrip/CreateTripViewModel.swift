import Foundation
import Combine

final class CreateTripViewModel {
    var onTripCreated: ((Trip) -> Void)?
    private let adminId: Int64
    @Published var title: String = ""
    @Published var budget: String = ""
    @Published var description: String = ""
    @Published var participantIds: [Int64] = []
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()

    @Published private(set) var isSaveEnabled = false

    private var cancellables = Set<AnyCancellable>()

    init(adminId: Int64 = 0) {
        self.adminId = adminId
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
        guard let budgetValue = Double(budget) else { return }
        let dto = TripDtoForCreate(
            title: title,
            startDate: startDate,
            endDate: endDate,
            status: .planning,
            budget: budgetValue,
            description: description,
            participantIds: participantIds
        )

        MockAPIService.shared.createTrip(dto, adminId: adminId) { [weak self] trip in
            DispatchQueue.main.async {
                self?.onTripCreated?(trip)
            }
        }
    }
}
