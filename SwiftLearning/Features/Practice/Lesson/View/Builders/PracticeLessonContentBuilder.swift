import Foundation

struct PracticeLessonContentBuilder {
    // MARK: - Public methods -

    func build(
        session: PracticeSessionState,
        topicTitle: String
    ) -> PracticeLessonContentViewModel? {
        guard let currentTask = session.currentTask else { return nil }

        return PracticeLessonContentViewModel(
            topicTitle: topicTitle,
            task: buildTask(
                from: currentTask,
                selectedAnswerIndex: session.selectedAnswerIndex
            ),
            progressTitle: L10n.format(
                "practice.questionProgress",
                session.currentQuestionNumber,
                session.taskCount
            ),
            progressValue: Double(session.currentQuestionNumber) / Double(session.taskCount),
            isAnswered: session.isAnswered,
            actionButtonTitle: actionButtonTitle(for: session),
            isActionButtonDisabled: session.isSavingResult || session.isWaitingForRequiredTasks,
            answerExplanationViewModel: buildAnswerExplanation(
                for: currentTask,
                selectedAnswerIndex: session.selectedAnswerIndex
            ),
            paginationErrorMessage: session.blockingPaginationErrorMessage
        )
    }

    // MARK: - Private methods -

    private func actionButtonTitle(for session: PracticeSessionState) -> String {
        if session.isSavingResult {
            return L10n.string("common.saving")
        }

        if session.isWaitingForRequiredTasks {
            return L10n.string("common.loadingEllipsis")
        }

        return session.isLastTask && !session.pagination.hasMore
            ? L10n.string("practice.seeResults")
            : L10n.string("practice.nextQuestion")
    }

    private func buildTask(
        from task: PracticeTaskViewModel,
        selectedAnswerIndex: Int?
    ) -> PracticeTaskViewModel {
        PracticeTaskViewModel(
            id: task.id,
            question: task.question,
            code: task.code,
            explanation: task.explanation,
            difficulty: task.difficulty,
            tags: task.tags,
            answers: visibleAnswerIndices(
                in: task.answers,
                selectedAnswerIndex: selectedAnswerIndex
            ).map { index in
                buildAnswer(
                    from: task.answers[index],
                    at: index,
                    in: task.answers,
                    selectedAnswerIndex: selectedAnswerIndex
                )
            }
        )
    }

    private func visibleAnswerIndices(
        in answers: [PracticeAnswerViewModel],
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
        from answer: PracticeAnswerViewModel,
        at index: Int,
        in answers: [PracticeAnswerViewModel],
        selectedAnswerIndex: Int?
    ) -> PracticeAnswerViewModel {
        PracticeAnswerViewModel(
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
        in answers: [PracticeAnswerViewModel],
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
        for task: PracticeTaskViewModel,
        selectedAnswerIndex: Int?
    ) -> AnswerExplanationViewModel? {
        guard let selectedAnswerIndex else { return nil }

        let isCorrect = task.answers[selectedAnswerIndex].isCorrect
        return AnswerExplanationViewModel(
            isCorrect: isCorrect,
            explanation: task.explanation,
            correctAnswer: isCorrect ? nil : correctAnswerText(in: task.answers)
        )
    }

    private func correctAnswerText(in answers: [PracticeAnswerViewModel]) -> String? {
        answers.first { $0.isCorrect }?.text
    }
}
