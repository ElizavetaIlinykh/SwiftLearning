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
    private struct SessionState {
        var tasks: [PracticeTaskViewModel] = []
        var currentTaskIndex = 0
        var selectedAnswerIndex: Int?
        var correctAnswersCount = 0
        var totalAnswersCount = 0
    }

    private struct PaginationState {
        var hasMore = false
        var isLoading = false
        var error: String?
    }

    // MARK: - Private properties -

    private let tasksManager: PracticeTasksManager
    private let taskBuilder: PracticeTaskBuilder
    private let output: (PracticeSessionOutput) -> Void
    private var session = SessionState()
    private var pagination = PaginationState()
    private var completionState: PracticeCompletionState = .idle

    // MARK: - Public properties -

    @Published private(set) var state: PracticeSessionViewState = .loading

    // MARK: - Init -

    init(
        tasksManager: PracticeTasksManager,
        taskBuilder: PracticeTaskBuilder,
        output: @escaping (PracticeSessionOutput) -> Void
    ) {
        self.tasksManager = tasksManager
        self.taskBuilder = taskBuilder
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
        guard let currentTask else { return }

        await loadMoreTasks { [tasksManager] in
            try await tasksManager.loadMoreTasksIfNeeded(currentTaskID: currentTask.id)
        }
    }

    func selectAnswer(answerID: String) {
        guard session.selectedAnswerIndex == nil else { return }
        guard let currentTask else { return }
        guard let answerIndex = currentTask.answers.firstIndex(where: { $0.id == answerID }) else { return }

        session.selectedAnswerIndex = answerIndex
        session.totalAnswersCount += 1

        if currentTask.answers[answerIndex].isCorrect {
            session.correctAnswersCount += 1
        }

        updateStateFromTasks()
    }

    func advance() async {
        guard !session.tasks.isEmpty else { return }

        if isLastTask, pagination.hasMore {
            let previousTaskCount = session.tasks.count
            await loadMoreTasks { [tasksManager] in
                try await tasksManager.loadMoreTasks()
            }

            if session.tasks.count > previousTaskCount {
                moveToNextTask()
            } else if !pagination.hasMore {
                await saveResult()
            }
            return
        }

        if isLastTask {
            await saveResult()
        } else {
            moveToNextTask()
        }
    }

    func closePractice() {
        output(.closePractice)
    }

    // MARK: - Private properties -

    private var currentTask: PracticeTaskViewModel? {
        guard !session.tasks.isEmpty else { return nil }
        let safeTaskIndex = min(session.currentTaskIndex, session.tasks.count - 1)
        return session.tasks[safeTaskIndex]
    }

    private var isAnswered: Bool {
        session.selectedAnswerIndex != nil
    }

    private var isLastTask: Bool {
        session.currentTaskIndex == session.tasks.count - 1
    }

    private var isSavingResult: Bool {
        if case .saving = completionState {
            return true
        }
        return false
    }

    // MARK: - Private methods -

    private func resetProgress() {
        session = SessionState()
        pagination = PaginationState()
        completionState = .idle
    }

    private func setLoadedPage(_ page: PracticeTasksPage) {
        session.tasks = taskBuilder.build(tasks: page.tasks)
        pagination.hasMore = page.hasMore
        updateStateFromTasks()
    }

    private func updateStateFromTasks() {
        guard let currentTask else {
            state = .empty
            return
        }

        state = .content(
            PracticeSessionContentViewModel(
                task: taskViewModel(
                    from: currentTask,
                    selectedAnswerIndex: session.selectedAnswerIndex
                ),
                progressTitle: L10n.format("practice.questionProgress", session.currentTaskIndex + 1, session.tasks.count),
                progressValue: Double(session.currentTaskIndex + 1) / Double(session.tasks.count),
                isAnswered: isAnswered,
                actionButtonTitle: actionButtonTitle,
                isActionButtonDisabled: isSavingResult || pagination.isLoading,
                answerExplanationViewModel: answerExplanationViewModel(for: currentTask),
                isLoadingMoreTasks: pagination.isLoading,
                loadMoreTasksError: pagination.error
            )
        )
    }

    private func taskViewModel(
        from task: PracticeTaskViewModel,
        selectedAnswerIndex: Int?
    ) -> PracticeTaskViewModel {
        PracticeTaskViewModel(
            id: task.id,
            question: task.question,
            code: task.code,
            explanation: task.explanation,
            difficulty: task.difficulty,
            tags: task.tags,
            answers: visibleAnswerIndices(
                in: task.answers,
                selectedAnswerIndex: selectedAnswerIndex
            ).map { index in
                answerViewModel(
                    from: task.answers[index],
                    at: index,
                    in: task.answers,
                    selectedAnswerIndex: selectedAnswerIndex
                )
            }
        )
    }

    private func visibleAnswerIndices(
        in answers: [PracticeAnswerViewModel],
        selectedAnswerIndex: Int?
    ) -> [Int] {
        guard let selectedAnswerIndex else {
            return Array(answers.indices)
        }

        return answers.indices.filter { index in
            index == selectedAnswerIndex || answers[index].isCorrect
        }
    }

    private func answerViewModel(
        from answer: PracticeAnswerViewModel,
        at index: Int,
        in answers: [PracticeAnswerViewModel],
        selectedAnswerIndex: Int?
    ) -> PracticeAnswerViewModel {
        PracticeAnswerViewModel(
            id: answer.id,
            text: answer.text,
            isCorrect: answer.isCorrect,
            state: optionState(
                for: index,
                in: answers,
                selectedAnswerIndex: selectedAnswerIndex
            )
        )
    }

    private func optionState(
        for index: Int,
        in answers: [PracticeAnswerViewModel],
        selectedAnswerIndex: Int?
    ) -> AnswerOptionState {
        guard let selectedAnswerIndex else { return .neutral }

        if index == selectedAnswerIndex, answers[index].isCorrect {
            return .selectedCorrect
        }

        if index == selectedAnswerIndex {
            return .selectedIncorrect
        }

        if answers[index].isCorrect {
            return .correct
        }

        return .neutral
    }

    private func answerExplanationViewModel(
        for task: PracticeTaskViewModel
    ) -> AnswerExplanationViewModel? {
        guard let selectedAnswerIndex = session.selectedAnswerIndex else { return nil }

        let isCorrect = task.answers[selectedAnswerIndex].isCorrect
        return AnswerExplanationViewModel(
            isCorrect: isCorrect,
            explanation: task.explanation,
            correctAnswer: isCorrect ? nil : correctAnswerText(in: task.answers)
        )
    }

    private func correctAnswerText(in answers: [PracticeAnswerViewModel]) -> String? {
        answers.first { $0.isCorrect }?.text
    }

    private func loadMoreTasks(
        _ load: () async throws -> PracticeTasksPage
    ) async {
        guard pagination.hasMore, !pagination.isLoading else {
            return
        }

        pagination.isLoading = true
        pagination.error = nil
        updateStateFromTasks()

        do {
            let page = try await load()
            setLoadedPage(page)
        } catch is CancellationError {
            pagination.isLoading = false
            updateStateFromTasks()
        } catch {
            pagination.error = UserFacingErrorMessage.message(for: error)
            pagination.isLoading = false
            updateStateFromTasks()
        }
    }

    private func moveToNextTask() {
        session.currentTaskIndex += 1
        session.selectedAnswerIndex = nil
        completionState = .idle
        updateStateFromTasks()
    }

    private func saveResult() async {
        guard completionState != .saving else { return }
        guard !pagination.hasMore else { return }

        completionState = .saving
        updateStateFromTasks()

        do {
            let progress = try await tasksManager.completeTopic(
                correctAnswersCount: session.correctAnswersCount,
                totalAnswersCount: session.totalAnswersCount
            )
            completionState = .idle
            output(.openResult(progress: progress))
        } catch {
            completionState = .failed(UserFacingErrorMessage.message(for: error))
            updateStateFromTasks()
        }
    }

    private var actionButtonTitle: String {
        if isSavingResult {
            return L10n.string("common.saving")
        }

        if pagination.isLoading {
            return L10n.string("common.loadingEllipsis")
        }

        return isLastTask && !pagination.hasMore ? L10n.string("practice.seeResults") : L10n.string("practice.nextQuestion")
    }
}
