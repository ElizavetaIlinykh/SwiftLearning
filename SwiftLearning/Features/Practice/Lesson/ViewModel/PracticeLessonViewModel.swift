import Combine
import Foundation

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

    @Published private(set) var state: PracticeLessonViewState = .loading

    // MARK: - Init -

    init(
        tasksManager: PracticeTasksManager,
        taskBuilder: PracticeTaskBuilder,
        contentBuilder: PracticeLessonContentBuilder,
        output: @escaping (PracticeLessonOutput) -> Void
    ) {
        self.tasksManager = tasksManager
        self.taskBuilder = taskBuilder
        self.contentBuilder = contentBuilder
        self.output = output
    }

    // MARK: - Public methods -

    func loadTasks() async {
        state = .loading
        resetProgress()

        do {
            let page = try await tasksManager.loadTasks()
            setLoadedPage(page)
        } catch is CancellationError {
            return
        } catch {
            state = .error(UserFacingErrorMessage.message(for: error))
        }
    }

    func refreshTasks() async {
        await loadTasks()
    }

    func loadMoreTasksIfNeeded() async {
        guard let currentTask = session.currentTask else { return }

        await loadMoreTasks { [tasksManager] in
            try await tasksManager.loadMoreTasksIfNeeded(currentTaskID: currentTask.id)
        }
    }

    func selectAnswer(answerID: String) {
        session.selectAnswer(id: answerID)
        updateStateFromTasks()
    }

    func advance() async {
        guard session.hasTasks else { return }

        if session.isLastTask, session.pagination.hasMore {
            let previousTaskCount = session.taskCount
            await loadMoreTasks { [tasksManager] in
                try await tasksManager.loadMoreTasks()
            }

            if session.taskCount > previousTaskCount {
                moveToNextTask()
            } else if !session.pagination.hasMore {
                await saveResult()
            }
            return
        }

        if session.isLastTask {
            await saveResult()
        } else {
            moveToNextTask()
        }
    }

    func closePractice() {
        output(.closePractice)
    }

    // MARK: - Private methods -

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
        guard let content = contentBuilder.build(session: session) else {
            state = .empty
            return
        }

        state = .content(content)
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
