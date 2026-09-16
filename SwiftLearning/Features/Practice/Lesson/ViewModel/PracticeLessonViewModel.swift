import Combine
import Foundation

enum PracticeLessonAction {
    case load
    case refresh
    case retry
    case selectAnswer(String)
    case advance
    case close
}

enum PracticeLessonOutput {
    case closePractice
    case openResult(progress: PracticeProgress)
}

@MainActor
final class PracticeLessonViewModel: ObservableObject {
    // MARK: - Private properties -

    private let tasksManager: PracticeTasksManager
    private let taskBuilder: PracticeTaskBuilder
    private let contentBuilder: PracticeLessonContentBuilder
    private let output: (PracticeLessonOutput) -> Void
    private var session = PracticeSessionState()

    // MARK: - Public properties -

    let topicTitle: String
    @Published private(set) var state: PracticeLessonViewState = .loading

    // MARK: - Init -

    init(
        topicTitle: String,
        tasksManager: PracticeTasksManager,
        taskBuilder: PracticeTaskBuilder,
        contentBuilder: PracticeLessonContentBuilder,
        output: @escaping (PracticeLessonOutput) -> Void
    ) {
        self.topicTitle = topicTitle
        self.tasksManager = tasksManager
        self.taskBuilder = taskBuilder
        self.contentBuilder = contentBuilder
        self.output = output
    }

    // MARK: - Public methods -

    func handle(_ action: PracticeLessonAction) async {
        switch action {
        case .load, .retry:
            await loadTasks()
        case .refresh:
            await refreshTasks()
        case let .selectAnswer(answerID):
            selectAnswer(answerID: answerID)
        case .advance:
            await advance()
        case .close:
            closePractice()
        }
    }

    // MARK: - Private methods -

    private func loadTasks() async {
        state = .loading
        resetProgress()

        do {
            let page = try await tasksManager.loadTasks()
            setLoadedPage(page)
            await loadMoreTasksIfNeededForCurrentTask()
        } catch is CancellationError {
            return
        } catch {
            state = .error(UserFacingErrorMessage.message(for: error))
        }
    }

    private func refreshTasks() async {
        await loadTasks()
    }

    private func selectAnswer(answerID: String) {
        session.selectAnswer(id: answerID)
        updateStateFromTasks()
    }

    private func advance() async {
        guard session.hasTasks else { return }

        if session.isLastTask {
            if session.pagination.hasMore {
                await loadNextPageAndAdvanceIfPossible()
            } else {
                await saveResult()
            }
            return
        }

        moveToNextTask()
        await loadMoreTasksIfNeededForCurrentTask()
    }

    private func closePractice() {
        output(.closePractice)
    }

    private func resetProgress() {
        session = PracticeSessionState()
    }

    private func setLoadedPage(_ page: PracticeTasksPage) {
        session.setTasks(
            taskBuilder.build(tasks: page.tasks),
            hasMore: page.hasMore
        )
        updateStateFromTasks()
    }

    private func updateStateFromTasks() {
        guard let content = contentBuilder.build(
            session: session,
            topicTitle: topicTitle
        ) else {
            state = .empty
            return
        }

        state = .content(content)
    }

    private func loadMoreTasksIfNeededForCurrentTask() async {
        guard let currentTask = session.currentTask else { return }

        await loadMoreTasks { [tasksManager] in
            try await tasksManager.loadMoreTasksIfNeeded(currentTaskID: currentTask.id)
        }
    }

    private func loadNextPageAndAdvanceIfPossible() async {
        let previousTaskCount = session.taskCount
        await loadMoreTasks { [tasksManager] in
            try await tasksManager.loadMoreTasks()
        }

        if session.taskCount > previousTaskCount {
            moveToNextTask()
            await loadMoreTasksIfNeededForCurrentTask()
        } else if !session.pagination.hasMore {
            await saveResult()
        }
    }

    private func loadMoreTasks(
        _ load: () async throws -> PracticeTasksPage
    ) async {
        guard session.canLoadMore else {
            return
        }

        session.startLoadingMore()
        updateStateFromTasks()

        do {
            let page = try await load()
            setLoadedPage(page)
        } catch is CancellationError {
            session.cancelLoadingMore()
            updateStateFromTasks()
        } catch {
            session.failLoadingMore(message: UserFacingErrorMessage.message(for: error))
            updateStateFromTasks()
        }
    }

    private func moveToNextTask() {
        session.moveToNextTask()
        updateStateFromTasks()
    }

    private func saveResult() async {
        guard session.canSaveResult else { return }

        session.startSaving()
        updateStateFromTasks()

        do {
            let progress = try await tasksManager.completeTopic(
                correctAnswersCount: session.correctAnswersCount,
                totalAnswersCount: session.totalAnswersCount
            )
            session.finishSaving()
            output(.openResult(progress: progress))
        } catch {
            session.failSaving(message: UserFacingErrorMessage.message(for: error))
            updateStateFromTasks()
        }
    }
}
