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
    private var isLoading = false

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

    /// Loads quiz questions unless another load request is already running.
    ///
    /// - Returns: Questions returned by the backend.
    func loadQuestions() async throws -> [LessonQuizQuestion] {
        guard !isLoading else {
            throw CancellationError()
        }

        isLoading = true
        defer {
            isLoading = false
        }

        return try await lessonsService.fetchLessonQuestions(lessonID: lessonID)
    }
}
