import Foundation

@MainActor
final class LessonCompletionResultViewModel {
    // MARK: - Private properties -

    private let router: AppRouter

    // MARK: - Public properties -

    let lessonID: String

    // MARK: - Init -

    init(
        lessonID: String,
        router: AppRouter
    ) {
        self.lessonID = lessonID
        self.router = router
    }

    // MARK: - Public methods -

    func continueLearning() {
        router.popLessonsToRoot()
    }
}
