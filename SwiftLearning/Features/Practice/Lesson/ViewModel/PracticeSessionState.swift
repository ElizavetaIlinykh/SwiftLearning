import Foundation

enum PracticeCompletionState: Equatable {
    case idle
    case saving
    case failed(String)
}

struct PracticeSessionState {
    struct PaginationState {
        var hasMore = false
        var isLoading = false
        var error: String?
    }

    private(set) var tasks: [PracticeTaskViewModel] = []
    private(set) var currentTaskIndex = 0
    private(set) var selectedAnswerIndex: Int?
    private(set) var correctAnswersCount = 0
    private(set) var totalAnswersCount = 0
    private(set) var pagination = PaginationState()
    private(set) var completionState: PracticeCompletionState = .idle

    var currentTask: PracticeTaskViewModel? {
        guard !tasks.isEmpty else { return nil }
        let safeTaskIndex = min(currentTaskIndex, tasks.count - 1)
        return tasks[safeTaskIndex]
    }

    var isAnswered: Bool {
        selectedAnswerIndex != nil
    }

    var isLastTask: Bool {
        currentTaskIndex == tasks.count - 1
    }

    var isSavingResult: Bool {
        if case .saving = completionState {
            return true
        }
        return false
    }

    var hasTasks: Bool {
        !tasks.isEmpty
    }

    var canLoadMore: Bool {
        pagination.hasMore && !pagination.isLoading
    }

    var canSaveResult: Bool {
        completionState != .saving && !pagination.hasMore
    }

    var taskCount: Int {
        tasks.count
    }

    var currentQuestionNumber: Int {
        currentTaskIndex + 1
    }

    mutating func setTasks(_ tasks: [PracticeTaskViewModel], hasMore: Bool) {
        self.tasks = tasks
        pagination.hasMore = hasMore
        pagination.isLoading = false
        pagination.error = nil

        guard !tasks.isEmpty else {
            currentTaskIndex = 0
            selectedAnswerIndex = nil
            return
        }

        currentTaskIndex = min(currentTaskIndex, tasks.count - 1)
    }

    mutating func selectAnswer(id: String) {
        guard selectedAnswerIndex == nil else { return }
        guard let currentTask else { return }
        guard let answerIndex = currentTask.answers.firstIndex(where: { $0.id == id }) else { return }

        selectedAnswerIndex = answerIndex
        totalAnswersCount += 1

        if currentTask.answers[answerIndex].isCorrect {
            correctAnswersCount += 1
        }
    }

    mutating func moveToNextTask() {
        guard currentTaskIndex < tasks.count else { return }

        currentTaskIndex += 1
        selectedAnswerIndex = nil
        completionState = .idle
    }

    mutating func startLoadingMore() {
        pagination.isLoading = true
        pagination.error = nil
    }

    mutating func cancelLoadingMore() {
        pagination.isLoading = false
    }

    mutating func failLoadingMore(message: String) {
        pagination.error = message
        pagination.isLoading = false
    }

    mutating func startSaving() {
        completionState = .saving
    }

    mutating func finishSaving() {
        completionState = .idle
    }

    mutating func failSaving(message: String) {
        completionState = .failed(message)
    }
}
