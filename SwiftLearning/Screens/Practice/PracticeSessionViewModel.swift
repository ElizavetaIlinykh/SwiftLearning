import Combine
import Foundation

enum PracticeCompletionState: Equatable {
    case idle
    case saving
    case saved(PracticeProgress)
    case failed(String)
}

@MainActor
final class PracticeSessionViewModel: ObservableObject {
    @Published private(set) var completionState: PracticeCompletionState = .idle

    private let tasksManager: PracticeTasksManager
    private let practiceService: PracticeServicing
    private var cancellables: Set<AnyCancellable> = []

    let topicID: String
    let topicTitle: String

    var state: PracticeTasksLoadingState {
        tasksManager.state
    }

    var tasks: [PracticeTask] {
        guard case .loaded(let tasks) = state else { return [] }
        return tasks.sorted { $0.order < $1.order }
    }

    init(
        topicID: String,
        topicTitle: String,
        tasksManager: PracticeTasksManager,
        practiceService: PracticeServicing
    ) {
        self.topicID = topicID
        self.topicTitle = topicTitle
        self.tasksManager = tasksManager
        self.practiceService = practiceService
        bindTasksManagerUpdates()
    }

    func loadTasks() async {
        await tasksManager.loadTasks()
    }

    func saveResult(
        correctAnswersCount: Int,
        totalAnswersCount: Int
    ) async -> PracticeProgress? {
        guard completionState != .saving else { return nil }

        completionState = .saving

        do {
            let progress = try await practiceService.completeTopic(
                topicID: topicID,
                correctAnswersCount: correctAnswersCount,
                totalAnswersCount: totalAnswersCount
            )
            completionState = .saved(progress)
            return progress
        } catch {
            completionState = .failed(error.localizedDescription)
            return nil
        }
    }

    private func bindTasksManagerUpdates() {
        tasksManager.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
