import Combine
import Foundation

@MainActor
final class LessonQuizViewModel: ObservableObject {
    // MARK: - Private properties -

    private let quizManager: LessonQuizManager
    private let contentBuilder: LessonQuizContentBuilder
    private let onOpenCodeTask: (String) -> Void

    // MARK: - Public properties -

    let lessonID: String
    @Published private(set) var state: LessonQuizViewState = .loading

    // MARK: - Init -

    init(
        lessonID: String,
        quizManager: LessonQuizManager,
        contentBuilder: LessonQuizContentBuilder,
        onOpenCodeTask: @escaping (String) -> Void
    ) {
        self.lessonID = lessonID
        self.quizManager = quizManager
        self.contentBuilder = contentBuilder
        self.onOpenCodeTask = onOpenCodeTask
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
        onOpenCodeTask(lessonID)
    }

    // MARK: - Private methods -

    private func makeState(questions: [LessonQuizQuestion]) -> LessonQuizViewState {
        guard !questions.isEmpty else { return .empty }
        return .content(contentBuilder.build(questions: questions))
    }
}
