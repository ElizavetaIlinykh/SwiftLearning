import Foundation

enum LessonCodeTaskLoadingState: Equatable {
    case idle
    case loading
    case loaded(LessonCodeTask)
    case notAvailable
    case failed(String)
}

/// Loads the code task for a lesson.
///
/// Missing code tasks are surfaced as `LessonCodeTaskError.notFound`
@MainActor
final class LessonCodeTaskManager {
    // MARK: - Private properties -

    private let lessonID: String
    private let lessonsService: LessonsServicing
    private var isLoading = false

    // MARK: - Init -

    /// Creates a code task manager for the given lesson.
    ///
    /// - Parameters:
    ///   - lessonID: Identifier of the lesson whose code task should be loaded.
    ///   - lessonsService: Service used to fetch code tasks.
    init(
        lessonID: String,
        lessonsService: LessonsServicing
    ) {
        self.lessonID = lessonID
        self.lessonsService = lessonsService
    }

    // MARK: - Public methods -

    /// Loads the lesson code task unless another load request is already running.
    ///
    /// - Returns: The loaded code task.
    func loadCodeTask() async throws -> LessonCodeTask {
        guard !isLoading else {
            throw CancellationError()
        }

        isLoading = true
        defer {
            isLoading = false
        }

        return try await lessonsService.fetchLessonCodeTask(lessonID: lessonID)
    }
}
