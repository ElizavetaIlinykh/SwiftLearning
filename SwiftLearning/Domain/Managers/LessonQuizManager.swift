import Foundation

typealias LessonQuizLoadingState = LoadingState<[LessonQuizQuestion]>

/// Loads quiz questions for a lesson.
///
/// The manager owns the loading request and exposes the loaded data through its async API.
@MainActor
final class LessonQuizManager {
    // MARK: - Private properties -

    private let lessonID: String
    private let lessonsService: LessonsServicing
    private var currentTask: Task<[LessonQuizQuestion], Error>?

    // MARK: - Init -

    /// Creates a quiz manager for the given lesson.
    ///
    /// - Parameters:
    ///   - lessonID: Identifier of the lesson whose quiz should be loaded.
    ///   - lessonsService: Service used to fetch quiz questions.
    init(
        lessonID: String,
        lessonsService: LessonsServicing
    ) {
        self.lessonID = lessonID
        self.lessonsService = lessonsService
    }

    // MARK: - Public methods -

    /// Loads quiz questions, sharing an in-flight request when one is already running.
    ///
    /// - Returns: Questions returned by the backend.
    func loadQuestions() async throws -> [LessonQuizQuestion] {
        if let currentTask {
            return try await currentTask.value
        }

        let task = Task { @MainActor in
            try await lessonsService.fetchLessonQuestions(lessonID: lessonID)
        }
        currentTask = task

        defer {
            currentTask = nil
        }

        return try await task.value
    }
}
