import Combine
import Foundation

enum PracticeTasksLoadingState: Equatable {
    case idle
    case loading
    case loaded([PracticeTask])
    case failed(String)
}

@MainActor
final class PracticeTasksManager: ObservableObject {
    @Published private(set) var state: PracticeTasksLoadingState = .idle

    private let topicID: String
    private let practiceService: PracticeServicing

    init(
        topicID: String,
        practiceService: PracticeServicing
    ) {
        self.topicID = topicID
        self.practiceService = practiceService
    }

    func loadTasks() async {
        guard state != .loading else { return }

        state = .loading

        do {
            let tasks = try await practiceService.fetchTasks(topicID: topicID)
            state = .loaded(tasks)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
