import Foundation

typealias LessonDetailsLoadingState = LoadingState<LessonDetails>

/// Loads details for a single lesson.
///
/// The manager keeps request details away from `LessonViewModel`, but does not own UI state.
@MainActor
final class LessonDetailsManager {
    // MARK: - Private properties -

    private let lessonID: String
    private let lessonsService: LessonsServicing
    private var currentTask: Task<LessonDetails, Error>?

    // MARK: - Init -

    /// Creates a lesson details manager.
    ///
    /// - Parameters:
    ///   - lessonID: Identifier of the lesson to load.
    ///   - lessonsService: Service used to fetch lesson details.
    init(
        lessonID: String,
        lessonsService: LessonsServicing
    ) {
        self.lessonID = lessonID
        self.lessonsService = lessonsService
    }

    // MARK: - Public methods -

    /// Loads lesson details, sharing an in-flight request when one is already running.
    ///
    /// - Returns: Loaded lesson details.
    func loadLesson() async throws -> LessonDetails {
        if let currentTask {
            return try await currentTask.value
        }

        let task = Task { @MainActor in
            try await lessonsService.fetchLesson(id: lessonID)
        }
        currentTask = task

        defer {
            currentTask = nil
        }

        return try await task.value
    }
}
