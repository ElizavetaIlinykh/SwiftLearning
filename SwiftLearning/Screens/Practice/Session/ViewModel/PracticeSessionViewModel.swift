import Combine
import Foundation

enum PracticeCompletionState: Equatable {
    case idle
    case saving
    case failed(String)
}

enum PracticeSessionOutput {
    case closePractice
    case openResult(progress: PracticeProgress)
}

@MainActor
final class PracticeSessionViewModel: ObservableObject {
    // MARK: - Private properties -

    private let tasksManager: PracticeTasksManager
    private let taskBuilder: PracticeTaskBuilder
    private let output: (PracticeSessionOutput) -> Void
    private var tasks: [PracticeTask] = []

    // MARK: - Public properties -

    @Published private(set) var state: PracticeSessionViewState = .loading
    @Published private(set) var hasMoreTasks = false
    @Published private(set) var isLoadingMoreTasks = false
    @Published private(set) var loadMoreTasksError: String?
    @Published private(set) var completionState: PracticeCompletionState = .idle

    let topicID: String
    let topicTitle: String

    var taskCount: Int {
        tasks.count
    }

    // MARK: - Init -

    init(
        topicID: String,
        topicTitle: String,
        tasksManager: PracticeTasksManager,
        taskBuilder: PracticeTaskBuilder,
        output: @escaping (PracticeSessionOutput) -> Void
    ) {
        self.topicID = topicID
        self.topicTitle = topicTitle
        self.tasksManager = tasksManager
        self.taskBuilder = taskBuilder
        self.output = output
    }

    // MARK: - Public methods -

    func loadTasks() async {
        state = .loading
        tasks = []
        hasMoreTasks = false
        isLoadingMoreTasks = false
        loadMoreTasksError = nil

        do {
            let page = try await tasksManager.loadTasks()
            setLoadedPage(page)
        } catch is CancellationError {
            return
        } catch {
            state = .error(UserFacingErrorMessage.message(for: error))
        }
    }

    func loadMoreTasksIfNeeded(currentTaskID: String) async {
        await loadMoreTasks { [tasksManager] in
            try await tasksManager.loadMoreTasksIfNeeded(currentTaskID: currentTaskID)
        }
    }

    func loadMoreTasks() async {
        await loadMoreTasks { [tasksManager] in
            try await tasksManager.loadMoreTasks()
        }
    }

    func saveResult(
        correctAnswersCount: Int,
        totalAnswersCount: Int
    ) async -> PracticeProgress? {
        guard completionState != .saving else { return nil }
        guard !hasMoreTasks else { return nil }

        completionState = .saving

        do {
            let progress = try await tasksManager.completeTopic(
                correctAnswersCount: correctAnswersCount,
                totalAnswersCount: totalAnswersCount
            )
            completionState = .idle
            return progress
        } catch {
            completionState = .failed(UserFacingErrorMessage.message(for: error))
            return nil
        }
    }

    func closePractice() {
        output(.closePractice)
    }

    func openResult(progress: PracticeProgress) {
        output(.openResult(progress: progress))
    }

    // MARK: - Private methods -

    private func loadMoreTasks(
        _ load: () async throws -> PracticeTasksPage
    ) async {
        guard hasMoreTasks, !isLoadingMoreTasks else {
            return
        }

        isLoadingMoreTasks = true
        loadMoreTasksError = nil

        do {
            let page = try await load()
            setLoadedPage(page)
        } catch is CancellationError {
            return
        } catch {
            loadMoreTasksError = UserFacingErrorMessage.message(for: error)
        }

        isLoadingMoreTasks = false
    }

    private func setLoadedPage(_ page: PracticeTasksPage) {
        tasks = page.tasks
        hasMoreTasks = page.hasMore
        updateStateFromTasks()
    }

    private func updateStateFromTasks() {
        if tasks.isEmpty {
            state = .empty
        } else {
            state = .content(
                PracticeSessionContentViewModel(
                    tasks: taskBuilder.build(tasks: tasks)
                )
            )
        }
    }
}
