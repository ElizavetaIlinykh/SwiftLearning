import Foundation

struct LessonQuizContentBuilder {
    // MARK: - Public methods -

    func build(progress: LessonQuizProgressState) -> LessonQuizContentViewModel? {
        guard let currentQuestion = progress.currentQuestion else { return nil }

        return LessonQuizContentViewModel(
            question: buildQuestion(
                currentQuestion,
                selectedAnswerIndex: progress.selectedAnswerIndex
            ),
            progressTitle: L10n.format(
                "quiz.progress.title",
                progress.currentQuestionNumber,
                progress.questionCount
            ),
            progressValue: Double(progress.currentQuestionNumber) / Double(progress.questionCount),
            isAnswered: progress.isAnswered,
            primaryButtonTitle: progress.isLastQuestion
                ? L10n.string("common.continue")
                : L10n.string("quiz.nextQuestion"),
            answerExplanationViewModel: buildAnswerExplanation(
                for: currentQuestion,
                selectedAnswerIndex: progress.selectedAnswerIndex
            )
        )
    }

    // MARK: - Private methods -

    private func buildQuestion(
        _ question: LessonQuizQuestion,
        selectedAnswerIndex: Int?
    ) -> LessonQuizQuestionViewModel {
        let answers = question.answers.sorted { $0.order < $1.order }

        return LessonQuizQuestionViewModel(
            id: question.id,
            text: question.text,
            explanation: question.explanation,
            difficulty: question.difficulty,
            tags: question.tags,
            answers: visibleAnswerIndices(
                in: answers,
                selectedAnswerIndex: selectedAnswerIndex
            ).map { index in
                buildAnswer(
                    answers[index],
                    at: index,
                    in: answers,
                    selectedAnswerIndex: selectedAnswerIndex
                )
            }
        )
    }

    private func visibleAnswerIndices(
        in answers: [LessonQuizAnswer],
        selectedAnswerIndex: Int?
    ) -> [Int] {
        guard let selectedAnswerIndex else {
            return Array(answers.indices)
        }

        return answers.indices.filter { index in
            index == selectedAnswerIndex || answers[index].isCorrect
        }
    }

    private func buildAnswer(
        _ answer: LessonQuizAnswer,
        at index: Int,
        in answers: [LessonQuizAnswer],
        selectedAnswerIndex: Int?
    ) -> LessonQuizAnswerViewModel {
        LessonQuizAnswerViewModel(
            id: answer.id,
            text: answer.text,
            isCorrect: answer.isCorrect,
            state: optionState(
                for: index,
                in: answers,
                selectedAnswerIndex: selectedAnswerIndex
            )
        )
    }

    private func optionState(
        for index: Int,
        in answers: [LessonQuizAnswer],
        selectedAnswerIndex: Int?
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

    private func buildAnswerExplanation(
        for question: LessonQuizQuestion,
        selectedAnswerIndex: Int?
    ) -> AnswerExplanationViewModel? {
        guard let selectedAnswerIndex else { return nil }

        let answers = question.answers.sorted { $0.order < $1.order }
        let isCorrect = answers[selectedAnswerIndex].isCorrect
        return AnswerExplanationViewModel(
            isCorrect: isCorrect,
            explanation: question.explanation,
            correctAnswer: isCorrect ? nil : correctAnswerText(in: answers)
        )
    }

    private func correctAnswerText(in answers: [LessonQuizAnswer]) -> String? {
        answers.first { $0.isCorrect }?.text
    }
}
