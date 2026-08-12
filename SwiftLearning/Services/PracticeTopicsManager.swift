import Combine
import Foundation

enum PracticeTopicsLoadingState: Equatable {
    case idle
    case loading
    case loaded([PracticeCategory])
    case failed(String)
}

@MainActor
final class PracticeTopicsManager: ObservableObject {
    @Published private(set) var state: PracticeTopicsLoadingState = .idle

    private let practiceService: PracticeServicing

    init(practiceService: PracticeServicing) {
        self.practiceService = practiceService
    }

    func loadTopics() async {
        guard state != .loading else { return }

        state = .loading

        do {
            let topics = try await practiceService.fetchTopics()
            state = .loaded(topics)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
