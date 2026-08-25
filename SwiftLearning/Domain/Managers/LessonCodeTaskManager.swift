import Foundation

enum LessonCodeTaskLoadingState: Equatable {
    case idle
    case loading
    case loaded(LessonCodeTask)
    case notAvailable
    case failed(String)
}

/// Coordinates the code task flow for a lesson.
///
/// Missing code tasks are surfaced as `LessonCodeTaskError.notFound`. UI-specific
/// loading and completion states are handled by `LessonCodeTaskViewModel`.
@MainActor
final class LessonCodeTaskManager {
    // MARK: - Private properties -

    private let lessonID: String
    private let lessonsService: LessonsServicing
    private var currentCodeTask: Task<LessonCodeTask, Error>?
    private var currentCompletionTask: Task<LessonProgress, Error>?

    // MARK: - Init -

    /// Creates a code task manager for the given lesson.
    ///
    /// - Parameters:
    ///   - lessonID: Identifier of the lesson whose code task should be loaded and completed.
    ///   - lessonsService: Service used to fetch code tasks and save lesson progress.
    init(
        lessonID: String,
        lessonsService: LessonsServicing
    ) {
        self.lessonID = lessonID
        self.lessonsService = lessonsService
    }

    // MARK: - Public methods -

    /// Loads the lesson code task, sharing an in-flight request when one is already running.
    ///
    /// - Returns: The loaded code task.
    func loadCodeTask() async throws -> LessonCodeTask {
        if let currentCodeTask {
            return try await currentCodeTask.value
        }

        let task = Task { @MainActor in
            try await lessonsService.fetchLessonCodeTask(lessonID: lessonID)
        }
        currentCodeTask = task

        defer {
            currentCodeTask = nil
        }

        return try await task.value
    }

    /// Marks the lesson as completed, sharing an in-flight request when one is already running.
    ///
    /// - Returns: Saved lesson progress.
    func completeLesson() async throws -> LessonProgress {
        if let currentCompletionTask {
            return try await currentCompletionTask.value
        }

        let task = Task { @MainActor in
            try await lessonsService.completeLesson(id: lessonID)
        }
        currentCompletionTask = task

        defer {
            currentCompletionTask = nil
        }

        return try await task.value
    }
}
