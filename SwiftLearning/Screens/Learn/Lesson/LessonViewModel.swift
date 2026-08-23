import Combine
import Foundation

@MainActor
final class LessonViewModel: ObservableObject {
    // MARK: - Private properties -

    private let lessonDetailsManager: LessonDetailsManager
    private let router: AppRouter

    // MARK: - Public properties -

    let totalLessonsCount: Int
    @Published private(set) var state: LessonDetailsLoadingState = .idle

    // MARK: - Init -

    init(
        lessonDetailsManager: LessonDetailsManager,
        totalLessonsCount: Int,
        router: AppRouter
    ) {
        self.lessonDetailsManager = lessonDetailsManager
        self.totalLessonsCount = totalLessonsCount
        self.router = router
    }

    // MARK: - Public methods -

    func loadLesson() async {
        state = .loading

        do {
            let lesson = try await lessonDetailsManager.loadLesson()
            state = .loaded(lesson)
        } catch is CancellationError {
            return
        } catch {
            state = .failed(UserFacingErrorMessage.message(for: error))
        }
    }

    func continueToQuiz(lessonID: String) {
        router.push(.quiz(lessonID: lessonID))
    }
}
