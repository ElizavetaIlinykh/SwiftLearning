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
    private var isLoadingCodeTask = false
    private var isCompletingLesson = false

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

    /// Loads the lesson code task unless another code task load request is already running.
    ///
    /// - Returns: The loaded code task.
    func loadCodeTask() async throws -> LessonCodeTask {
        guard !isLoadingCodeTask else {
            throw CancellationError()
        }

        isLoadingCodeTask = true
        defer {
            isLoadingCodeTask = false
        }

        return try await lessonsService.fetchLessonCodeTask(lessonID: lessonID)
    }

    /// Marks the lesson as completed unless completion is already in progress.
    ///
    /// - Returns: Saved lesson progress.
    func completeLesson() async throws -> LessonProgress {
        guard !isCompletingLesson else {
            throw CancellationError()
        }

        isCompletingLesson = true
        defer {
            isCompletingLesson = false
        }

        return try await lessonsService.completeLesson(id: lessonID)
    }
}
