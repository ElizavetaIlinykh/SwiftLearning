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
    // MARK: - Private properties -

    private let tasksManager: PracticeTasksManager
    private let practiceService: PracticeServicing
    private let router: AppRouter

    // MARK: - Public properties -

    @Published private(set) var state: PracticeTasksLoadingState = .idle
    @Published private(set) var hasMoreTasks = false
    @Published private(set) var isLoadingMoreTasks = false
    @Published private(set) var loadMoreTasksError: String?
    @Published private(set) var completionState: PracticeCompletionState = .idle

    let topicID: String
    let topicTitle: String

    var tasks: [PracticeTask] {
        guard case let .loaded(tasks) = state else { return [] }
        return tasks.sorted { $0.order < $1.order }
    }

    // MARK: - Init -

    init(
        topicID: String,
        topicTitle: String,
        tasksManager: PracticeTasksManager,
        practiceService: PracticeServicing,
        router: AppRouter
    ) {
        self.topicID = topicID
        self.topicTitle = topicTitle
        self.tasksManager = tasksManager
        self.practiceService = practiceService
        self.router = router
    }

    // MARK: - Public methods -

    func loadTasks() async {
        state = .loading
        hasMoreTasks = false
        isLoadingMoreTasks = false
        loadMoreTasksError = nil

        do {
            let page = try await tasksManager.loadTasks()
            setLoadedPage(page)
        } catch is CancellationError {
            return
        } catch {
            state = .failed(UserFacingErrorMessage.message(for: error))
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
            let progress = try await practiceService.completeTopic(
                topicID: topicID,
                correctAnswersCount: correctAnswersCount,
                totalAnswersCount: totalAnswersCount
            )
            completionState = .saved(progress)
            return progress
        } catch {
            completionState = .failed(UserFacingErrorMessage.message(for: error))
            return nil
        }
    }

    func closePractice() {
        router.popPracticeToRoot()
    }

    func openResult(progress: PracticeProgress) {
        router.push(
            .result(
                topicID: topicID,
                topicTitle: topicTitle,
                progress: progress
            )
        )
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
        state = .loaded(page.tasks)
        hasMoreTasks = page.hasMore
    }
}
