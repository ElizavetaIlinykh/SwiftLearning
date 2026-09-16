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

enum PracticeCompletionState: Equatable {
    case idle
    case saving
    case failed(String)
}

@MainActor
final class PracticeLessonViewModel: ObservableObject {
    // MARK: - Private properties -

    private let tasksManager: PracticeTasksManager
    private let contentBuilder: PracticeLessonContentBuilder
    private let output: (PracticeLessonOutput) -> Void
    private var lessonState = PracticeLessonState()

    // MARK: - Public properties -

    let topicTitle: String
    @Published private(set) var state: PracticeLessonViewState = .loading

    // MARK: - Init -

    init(
        topicTitle: String,
        tasksManager: PracticeTasksManager,
        contentBuilder: PracticeLessonContentBuilder,
        output: @escaping (PracticeLessonOutput) -> Void
    ) {
        self.topicTitle = topicTitle
        self.tasksManager = tasksManager
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
        lessonState.reset()

        do {
            let snapshot = try await tasksManager.loadTasks()
            lessonState.apply(snapshot)
            updateViewState()
            await prefetchTasksIfNeeded()
        } catch is CancellationError {
            return
        } catch {
            state = .error(UserFacingErrorMessage.message(for: error))
        }
    }

    private func refreshTasks() async {
        do {
            let snapshot = try await tasksManager.loadTasks()
            lessonState.apply(snapshot)
            updateViewState()
            await prefetchTasksIfNeeded()
        } catch is CancellationError {
            return
        } catch where !lessonState.session.hasTasks {
            state = .error(UserFacingErrorMessage.message(for: error))
        } catch {
            lessonState.failPagination(message: UserFacingErrorMessage.message(for: error))
            updateViewState()
        }
    }

    private func selectAnswer(answerID: String) {
        lessonState.selectAnswer(id: answerID)
        updateViewState()
    }

    private func advance() async {
        guard lessonState.session.hasTasks else { return }

        if lessonState.session.isLastTask {
            if lessonState.pagination.hasMore {
                await loadNextPageForAdvance()
            } else {
                await saveResult()
            }
            return
        }

        moveToNextTask()
        await prefetchTasksIfNeeded()
    }

    private func closePractice() {
        output(.closePractice)
    }

    private func updateViewState() {
        guard let content = contentBuilder.build(
            state: lessonState,
            topicTitle: topicTitle
        ) else {
            state = .empty
            return
        }

        state = .content(content)
    }

    private func prefetchTasksIfNeeded() async {
        guard let currentTask = lessonState.session.currentTask else { return }
        guard lessonState.canLoadMore else { return }

        lessonState.startPagination()
        updateViewState()

        do {
            let snapshot = try await tasksManager.loadMoreTasksIfNeeded(currentTaskID: currentTask.id)
            lessonState.apply(snapshot)
            updateViewState()
        } catch is CancellationError {
            lessonState.cancelPagination()
            updateViewState()
        } catch {
            lessonState.failPagination(message: UserFacingErrorMessage.message(for: error))
            updateViewState()
        }
    }

    private func loadNextPageForAdvance() async {
        let previousTaskCount = lessonState.session.taskCount
        guard lessonState.canLoadMore else { return }

        lessonState.startPagination()
        updateViewState()

        do {
            let snapshot = try await tasksManager.loadMoreTasks()
            lessonState.apply(snapshot)
            updateViewState()

            if lessonState.session.taskCount > previousTaskCount {
                moveToNextTask()
                await prefetchTasksIfNeeded()
            } else if !lessonState.pagination.hasMore {
                await saveResult()
            }
        } catch is CancellationError {
            lessonState.cancelPagination()
            updateViewState()
        } catch {
            lessonState.failPagination(message: UserFacingErrorMessage.message(for: error))
            updateViewState()
        }
    }

    private func moveToNextTask() {
        lessonState.moveToNextTask()
        updateViewState()
    }

    private func saveResult() async {
        guard lessonState.canSaveResult else { return }

        lessonState.startSaving()
        updateViewState()

        do {
            let progress = try await tasksManager.completeTopic(
                correctAnswersCount: lessonState.session.correctAnswersCount,
                totalAnswersCount: lessonState.session.totalAnswersCount
            )
            lessonState.finishSaving()
            output(.openResult(progress: progress))
        } catch {
            lessonState.failSaving(message: UserFacingErrorMessage.message(for: error))
            updateViewState()
        }
    }
}
