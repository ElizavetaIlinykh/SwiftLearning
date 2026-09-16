import Combine
import Foundation

enum LessonQuizAction {
    case load
    case refresh
    case retry
    case selectAnswer(Int)
    case advance
    case openCodeTask
}

enum LessonQuizOutput {
    case openCodeTask(lessonID: String)
}

@MainActor
final class LessonQuizViewModel: ObservableObject {
    // MARK: - Private properties -

    private let quizManager: LessonQuizManager
    private let contentBuilder: LessonQuizContentBuilder
    private let output: (LessonQuizOutput) -> Void
    private var quizProgress = LessonQuizProgressState()

    // MARK: - Public properties -

    let lessonID: String
    @Published private(set) var state: LessonQuizViewState = .loading

    // MARK: - Init -

    init(
        lessonID: String,
        quizManager: LessonQuizManager,
        contentBuilder: LessonQuizContentBuilder,
        output: @escaping (LessonQuizOutput) -> Void
    ) {
        self.lessonID = lessonID
        self.quizManager = quizManager
        self.contentBuilder = contentBuilder
        self.output = output
    }

    // MARK: - Public methods -

    func handle(_ action: LessonQuizAction) async {
        switch action {
        case .load, .retry:
            await loadQuestions()
        case .refresh:
            await refreshQuestions()
        case let .selectAnswer(index):
            selectAnswer(at: index)
        case .advance:
            advance()
        case .openCodeTask:
            openCodeTask()
        }
    }

    // MARK: - Private methods -

    private func loadQuestions() async {
        state = .loading
        resetQuizProgress()

        do {
            let loadedQuestions = try await quizManager.loadQuestions()
            quizProgress.setQuestions(loadedQuestions)
            updateViewState()
        } catch is CancellationError {
            return
        } catch {
            state = .error(UserFacingErrorMessage.message(for: error))
        }
    }

    private func refreshQuestions() async {
        do {
            let loadedQuestions = try await quizManager.loadQuestions()
            quizProgress.setQuestions(loadedQuestions)
            updateViewState()
        } catch is CancellationError {
            return
        } catch where quizProgress.questionCount == 0 {
            state = .error(UserFacingErrorMessage.message(for: error))
        } catch {
            return
        }
    }

    private func selectAnswer(at index: Int) {
        quizProgress.selectAnswer(at: index)
        updateViewState()
    }

    private func advance() {
        if quizProgress.isLastQuestion {
            openCodeTask()
        } else {
            quizProgress.moveToNextQuestion()
            updateViewState()
        }
    }

    private func openCodeTask() {
        output(.openCodeTask(lessonID: lessonID))
    }

    private func resetQuizProgress() {
        quizProgress = LessonQuizProgressState()
    }

    private func updateViewState() {
        guard let content = contentBuilder.build(progress: quizProgress) else {
            state = .empty
            return
        }

        state = .content(content)
    }
}
