import Foundation

struct LessonQuizContentBuilder {
    // MARK: - Public methods -

    func build(questions: [LessonQuizQuestion]) -> [LessonQuizQuestionViewModel] {
        questions
            .sorted { $0.order < $1.order }
            .map(buildQuestion)
    }

    // MARK: - Private methods -

    private func buildQuestion(_ question: LessonQuizQuestion) -> LessonQuizQuestionViewModel {
        LessonQuizQuestionViewModel(
            id: question.id,
            text: question.text,
            explanation: question.explanation,
            difficulty: question.difficulty,
            tags: question.tags,
            answers: question.answers
                .sorted { $0.order < $1.order }
                .map(buildAnswer)
        )
    }

    private func buildAnswer(_ answer: LessonQuizAnswer) -> LessonQuizAnswerViewModel {
        LessonQuizAnswerViewModel(
            id: answer.id,
            text: answer.text,
            isCorrect: answer.isCorrect,
            state: .neutral
        )
    }
}
