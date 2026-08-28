import Combine
import Foundation

enum LessonQuizOutput {
    case openCodeTask(lessonID: String)
}

@MainActor
final class LessonQuizViewModel: ObservableObject {
    // MARK: - Private properties -

    private let quizManager: LessonQuizManager
    private let contentBuilder: LessonQuizContentBuilder
    private let output: (LessonQuizOutput) -> Void
    private var questions: [LessonQuizQuestionViewModel] = []
    private var currentQuestionIndex = 0
    private var selectedAnswerIndex: Int?

    private var isAnswered: Bool {
        selectedAnswerIndex != nil
    }

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

    func loadQuestions() async {
        state = .loading
        resetQuizProgress()

        do {
            let loadedQuestions = try await quizManager.loadQuestions()
            questions = contentBuilder.build(questions: loadedQuestions)
            state = makeState()
        } catch is CancellationError {
            return
        } catch {
            state = .error(UserFacingErrorMessage.message(for: error))
        }
    }

    func selectAnswer(at index: Int) {
        guard selectedAnswerIndex == nil else { return }
        guard currentQuestion?.answers.indices.contains(index) == true else { return }

        selectedAnswerIndex = index
        state = makeState()
    }

    func advance() {
        if isLastQuestion {
            openCodeTask()
        } else {
            currentQuestionIndex += 1
            selectedAnswerIndex = nil
            state = makeState()
        }
    }

    func openCodeTask() {
        output(.openCodeTask(lessonID: lessonID))
    }

    // MARK: - Private properties -

    private var currentQuestion: LessonQuizQuestionViewModel? {
        guard !questions.isEmpty else { return nil }
        let safeQuestionIndex = min(currentQuestionIndex, questions.count - 1)
        return questions[safeQuestionIndex]
    }

    private var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }

    // MARK: - Private methods -

    private func resetQuizProgress() {
        questions = []
        currentQuestionIndex = 0
        selectedAnswerIndex = nil
    }

    private func makeState() -> LessonQuizViewState {
        guard let currentQuestion else { return .empty }

        return .content(
            LessonQuizContentViewModel(
                question: questionWithAnswerStates(currentQuestion),
                progressTitle: L10n.format("quiz.progress.title", currentQuestionIndex + 1, questions.count),
                progressValue: Double(currentQuestionIndex + 1) / Double(questions.count),
                isAnswered: isAnswered,
                primaryButtonTitle: isLastQuestion ? L10n.string("common.continue") : L10n.string("quiz.nextQuestion"),
                answerExplanationViewModel: answerExplanationViewModel(for: currentQuestion)
            )
        )
    }

    private func questionWithAnswerStates(
        _ question: LessonQuizQuestionViewModel
    ) -> LessonQuizQuestionViewModel {
        LessonQuizQuestionViewModel(
            id: question.id,
            text: question.text,
            explanation: question.explanation,
            difficulty: question.difficulty,
            tags: question.tags,
            answers: question.answers.indices.map { index in
                answerWithState(question.answers[index], at: index, in: question.answers)
            }
        )
    }

    private func answerWithState(
        _ answer: LessonQuizAnswerViewModel,
        at index: Int,
        in answers: [LessonQuizAnswerViewModel]
    ) -> LessonQuizAnswerViewModel {
        LessonQuizAnswerViewModel(
            id: answer.id,
            text: answer.text,
            isCorrect: answer.isCorrect,
            state: optionState(for: index, in: answers)
        )
    }

    private func optionState(
        for index: Int,
        in answers: [LessonQuizAnswerViewModel]
    ) -> AnswerOptionState {
        guard let selectedAnswerIndex else { return .neutral }

        if index == selectedAnswerIndex, answers[index].isCorrect {
            return .selectedCorrect
        }

        if index == selectedAnswerIndex {
            return .selectedIncorrect
        }

        if answers[index].isCorrect {
            return .correct
        }

        return .neutral
    }

    private func answerExplanationViewModel(
        for question: LessonQuizQuestionViewModel
    ) -> AnswerExplanationViewModel? {
        guard let selectedAnswerIndex else { return nil }

        let isCorrect = question.answers[selectedAnswerIndex].isCorrect
        return AnswerExplanationViewModel(
            isCorrect: isCorrect,
            explanation: question.explanation,
            correctAnswer: isCorrect ? nil : correctAnswerText(in: question.answers)
        )
    }

    private func correctAnswerText(in answers: [LessonQuizAnswerViewModel]) -> String? {
        answers.first { $0.isCorrect }?.text
    }
}
