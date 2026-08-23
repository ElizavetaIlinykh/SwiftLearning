import Combine
import Foundation

@MainActor
final class LessonQuizViewModel: ObservableObject {
    // MARK: - Private properties -

    private let quizManager: LessonQuizManager
    private let router: AppRouter

    // MARK: - Public properties -

    let lessonID: String
    @Published private(set) var state: LessonQuizLoadingState = .idle

    // MARK: - Init -

    init(
        lessonID: String,
        quizManager: LessonQuizManager,
        router: AppRouter
    ) {
        self.lessonID = lessonID
        self.quizManager = quizManager
        self.router = router
    }

    // MARK: - Public methods -

    func loadQuestions() async {
        state = .loading

        do {
            let questions = try await quizManager.loadQuestions()
            state = .loaded(questions)
        } catch is CancellationError {
            return
        } catch {
            state = .failed(UserFacingErrorMessage.message(for: error))
        }
    }

    func openCodeTask() {
        router.push(.codeTask(lessonID: lessonID))
    }
}
