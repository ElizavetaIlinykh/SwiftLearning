import Combine
import Foundation

enum LessonQuizOutput {
    case openCodeTask(lessonID: String)
}

@MainActor
final class LessonQuizViewModel: ObservableObject {
    private struct QuizProgressState {
        var questions: [LessonQuizQuestionViewModel] = []
        var currentQuestionIndex = 0
        var selectedAnswerIndex: Int?
    }

    // MARK: - Private properties -

    private let quizManager: LessonQuizManager
    private let contentBuilder: LessonQuizContentBuilder
    private let output: (LessonQuizOutput) -> Void
    private var quizProgress = QuizProgressState()

    private var isAnswered: Bool {
        quizProgress.selectedAnswerIndex != nil
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
            quizProgress.questions = contentBuilder.build(questions: loadedQuestions)
            state = makeState()
        } catch is CancellationError {
            return
        } catch {
            state = .error(UserFacingErrorMessage.message(for: error))
        }
    }

    func selectAnswer(at index: Int) {
        guard quizProgress.selectedAnswerIndex == nil else { return }
        guard currentQuestion?.answers.indices.contains(index) == true else { return }

        quizProgress.selectedAnswerIndex = index
        state = makeState()
    }

    func advance() {
        if isLastQuestion {
            openCodeTask()
        } else {
            quizProgress.currentQuestionIndex += 1
            quizProgress.selectedAnswerIndex = nil
            state = makeState()
        }
    }

    func openCodeTask() {
        output(.openCodeTask(lessonID: lessonID))
    }

    // MARK: - Private properties -

    private var currentQuestion: LessonQuizQuestionViewModel? {
        guard !quizProgress.questions.isEmpty else { return nil }
        let safeQuestionIndex = min(quizProgress.currentQuestionIndex, quizProgress.questions.count - 1)
        return quizProgress.questions[safeQuestionIndex]
    }

    private var isLastQuestion: Bool {
        quizProgress.currentQuestionIndex == quizProgress.questions.count - 1
    }

    // MARK: - Private methods -

    private func resetQuizProgress() {
        quizProgress = QuizProgressState()
    }

    private func makeState() -> LessonQuizViewState {
        guard let currentQuestion else { return .empty }

        return .content(
            LessonQuizContentViewModel(
                question: questionWithAnswerStates(currentQuestion),
                progressTitle: L10n.format("quiz.progress.title", quizProgress.currentQuestionIndex + 1, quizProgress.questions.count),
                progressValue: Double(quizProgress.currentQuestionIndex + 1) / Double(quizProgress.questions.count),
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
            answers: visibleAnswerIndices(in: question.answers).map { index in
                answerWithState(question.answers[index], at: index, in: question.answers)
            }
        )
    }

    private func visibleAnswerIndices(
        in answers: [LessonQuizAnswerViewModel]
    ) -> [Int] {
        guard let selectedAnswerIndex = quizProgress.selectedAnswerIndex else {
            return Array(answers.indices)
        }

        return answers.indices.filter { index in
            index == selectedAnswerIndex || answers[index].isCorrect
        }
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
        guard let selectedAnswerIndex = quizProgress.selectedAnswerIndex else { return .neutral }

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
        guard let selectedAnswerIndex = quizProgress.selectedAnswerIndex else { return nil }

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
