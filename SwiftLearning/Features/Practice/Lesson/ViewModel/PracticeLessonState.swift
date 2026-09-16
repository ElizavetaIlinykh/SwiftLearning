import Foundation

struct PracticeLessonState {
    struct PaginationState {
        var hasMore = false
        var isLoading = false
        var error: String?
    }

    private(set) var session = PracticeSessionState()
    private(set) var pagination = PaginationState()
    private(set) var completionState: PracticeCompletionState = .idle

    var isSavingResult: Bool {
        if case .saving = completionState {
            return true
        }
        return false
    }

    var canLoadMore: Bool {
        pagination.hasMore && !pagination.isLoading
    }

    var canSaveResult: Bool {
        completionState != .saving && !pagination.hasMore
    }

    var isWaitingForRequiredTasks: Bool {
        session.isLastTask && pagination.hasMore && pagination.isLoading
    }

    var blockingPaginationErrorMessage: String? {
        guard session.isLastTask, pagination.hasMore else { return nil }
        return pagination.error
    }

    mutating func reset() {
        session = PracticeSessionState()
        pagination = PaginationState()
        completionState = .idle
    }

    mutating func apply(_ snapshot: PracticeTasksSnapshot) {
        session.setTasks(snapshot.tasks)
        pagination.hasMore = snapshot.hasMore
        pagination.isLoading = false
        pagination.error = nil
    }

    mutating func selectAnswer(id: String) {
        session.selectAnswer(id: id)
    }

    mutating func moveToNextTask() {
        session.moveToNextTask()
        completionState = .idle
    }

    mutating func startPagination() {
        pagination.isLoading = true
        pagination.error = nil
    }

    mutating func cancelPagination() {
        pagination.isLoading = false
    }

    mutating func failPagination(message: String) {
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
