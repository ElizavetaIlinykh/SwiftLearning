import Combine
import Foundation

@MainActor
final class LessonQuizViewModel: ObservableObject {
    // MARK: - Private properties -

    private let quizManager: LessonQuizManager
    private let contentBuilder: LessonQuizContentBuilder
    private let router: AppRouter

    // MARK: - Public properties -

    let lessonID: String
    @Published private(set) var state: LessonQuizViewState = .loading

    // MARK: - Init -

    init(
        lessonID: String,
        quizManager: LessonQuizManager,
        contentBuilder: LessonQuizContentBuilder,
        router: AppRouter
    ) {
        self.lessonID = lessonID
        self.quizManager = quizManager
        self.contentBuilder = contentBuilder
        self.router = router
    }

    // MARK: - Public methods -

    func loadQuestions() async {
        state = .loading

        do {
            let questions = try await quizManager.loadQuestions()
            state = makeState(questions: questions)
        } catch is CancellationError {
            return
        } catch {
            state = .error(UserFacingErrorMessage.message(for: error))
        }
    }

    func openCodeTask() {
        router.push(.codeTask(lessonID: lessonID))
    }

    // MARK: - Private methods -

    private func makeState(questions: [LessonQuizQuestion]) -> LessonQuizViewState {
        guard !questions.isEmpty else { return .empty }
        return .content(contentBuilder.build(questions: questions))
    }
}
