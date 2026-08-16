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
    @Published private(set) var state: PracticeTasksLoadingState
    @Published private(set) var hasMoreTasks: Bool
    @Published private(set) var isLoadingMoreTasks: Bool
    @Published private(set) var loadMoreTasksError: String?
    @Published private(set) var completionState: PracticeCompletionState = .idle

    private let tasksManager: PracticeTasksManager
    private let practiceService: PracticeServicing
    private var cancellables: Set<AnyCancellable> = []

    let topicID: String
    let topicTitle: String

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
        self.state = tasksManager.state
        self.hasMoreTasks = tasksManager.hasMore
        self.isLoadingMoreTasks = tasksManager.isLoadingMore
        self.loadMoreTasksError = tasksManager.loadMoreError

        bindTasksManager()
    }

    func loadTasks() async {
        await tasksManager.loadTasks()
    }

    func loadMoreTasksIfNeeded(currentTaskID: String) async {
        await tasksManager.loadMoreTasksIfNeeded(currentTaskID: currentTaskID)
    }

    func loadMoreTasks() async {
        await tasksManager.loadMoreTasks()
    }

    func saveResult(
        correctAnswersCount: Int,
        totalAnswersCount: Int
    ) async -> PracticeProgress? {
        guard completionState != .saving else { return nil }
        guard !hasMoreTasks else { return nil }

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

    private func bindTasksManager() {
        tasksManager.$state
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)

        tasksManager.$hasMore
            .sink { [weak self] hasMoreTasks in
                self?.hasMoreTasks = hasMoreTasks
            }
            .store(in: &cancellables)

        tasksManager.$isLoadingMore
            .sink { [weak self] isLoadingMoreTasks in
                self?.isLoadingMoreTasks = isLoadingMoreTasks
            }
            .store(in: &cancellables)

        tasksManager.$loadMoreError
            .sink { [weak self] loadMoreTasksError in
                self?.loadMoreTasksError = loadMoreTasksError
            }
            .store(in: &cancellables)
    }
}
