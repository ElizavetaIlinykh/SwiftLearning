import Combine
import Foundation

typealias LessonDetailsLoadingState = LoadingState<LessonDetails>

@MainActor
final class LessonDetailsManager: ObservableObject {
    // MARK: - Private properties -

    @Published private(set) var state: LessonDetailsLoadingState = .idle
    private let lessonID: String
    private let lessonsService: LessonsServicing

    // MARK: - Init -

    init(
        lessonID: String,
        lessonsService: LessonsServicing
    ) {
        self.lessonID = lessonID
        self.lessonsService = lessonsService
    }

    // MARK: - Public methods -

    func loadLesson() async {
        guard state != .loading else { return }

        state = .loading

        do {
            let lesson = try await lessonsService.fetchLesson(id: lessonID)
            state = .loaded(lesson)
        } catch {
            state = .failed(UserFacingErrorMessage.message(for: error))
        }
    }
}
