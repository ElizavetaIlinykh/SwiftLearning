import Foundation

struct LessonQuizProgressState {
    private(set) var questions: [LessonQuizQuestion] = []
    private(set) var currentQuestionIndex = 0
    private(set) var selectedAnswerIndex: Int?

    var currentQuestion: LessonQuizQuestion? {
        guard questions.indices.contains(currentQuestionIndex) else { return nil }
        return questions[currentQuestionIndex]
    }

    var isAnswered: Bool {
        selectedAnswerIndex != nil
    }

    var isLastQuestion: Bool {
        guard !questions.isEmpty else { return false }
        return currentQuestionIndex == questions.count - 1
    }

    var questionCount: Int {
        questions.count
    }

    var currentQuestionNumber: Int {
        currentQuestionIndex + 1
    }

    mutating func setQuestions(_ questions: [LessonQuizQuestion]) {
        self.questions = questions.sorted { $0.order < $1.order }

        guard !self.questions.isEmpty else {
            currentQuestionIndex = 0
            selectedAnswerIndex = nil
            return
        }

        currentQuestionIndex = min(currentQuestionIndex, self.questions.count - 1)

        if let selectedAnswerIndex, currentQuestion?.answers.indices.contains(selectedAnswerIndex) == false {
            self.selectedAnswerIndex = nil
        }
    }

    mutating func selectAnswer(at index: Int) {
        guard selectedAnswerIndex == nil else { return }
        guard let currentQuestion else { return }
        let orderedAnswers = currentQuestion.answers.sorted { $0.order < $1.order }
        guard orderedAnswers.indices.contains(index) else { return }

        selectedAnswerIndex = index
    }

    mutating func moveToNextQuestion() {
        guard currentQuestionIndex + 1 < questions.count else { return }

        currentQuestionIndex += 1
        selectedAnswerIndex = nil
    }
}
