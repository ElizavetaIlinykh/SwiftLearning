import Foundation

struct PracticeLessonContentBuilder {
    // MARK: - Public methods -

    func build(
        state: PracticeLessonState,
        topicTitle: String
    ) -> PracticeLessonContentViewModel? {
        let session = state.session
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
            actionButtonTitle: actionButtonTitle(for: state),
            isActionButtonDisabled: state.isSavingResult || state.isWaitingForRequiredTasks,
            answerExplanationViewModel: buildAnswerExplanation(
                for: currentTask,
                selectedAnswerIndex: session.selectedAnswerIndex
            ),
            paginationErrorMessage: state.blockingPaginationErrorMessage
        )
    }

    // MARK: - Private methods -

    private func actionButtonTitle(for state: PracticeLessonState) -> String {
        if state.isSavingResult {
            return L10n.string("common.saving")
        }

        if state.isWaitingForRequiredTasks {
            return L10n.string("common.loadingEllipsis")
        }

        return state.session.isLastTask && !state.pagination.hasMore
            ? L10n.string("practice.seeResults")
            : L10n.string("practice.nextQuestion")
    }

    private func buildTask(
        from task: PracticeTask,
        selectedAnswerIndex: Int?
    ) -> PracticeTaskViewModel {
        let answers = task.answers.sorted { $0.order < $1.order }

        return PracticeTaskViewModel(
            id: task.id,
            question: task.question,
            code: task.code,
            explanation: task.explanation,
            difficulty: task.difficulty,
            tags: task.tags,
            answers: visibleAnswerIndices(
                in: answers,
                selectedAnswerIndex: selectedAnswerIndex
            ).map { index in
                buildAnswer(
                    from: answers[index],
                    at: index,
                    in: answers,
                    selectedAnswerIndex: selectedAnswerIndex
                )
            }
        )
    }

    private func visibleAnswerIndices(
        in answers: [PracticeAnswer],
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
        from answer: PracticeAnswer,
        at index: Int,
        in answers: [PracticeAnswer],
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
        in answers: [PracticeAnswer],
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
        for task: PracticeTask,
        selectedAnswerIndex: Int?
    ) -> AnswerExplanationViewModel? {
        guard let selectedAnswerIndex else { return nil }

        let answers = task.answers.sorted { $0.order < $1.order }
        let isCorrect = answers[selectedAnswerIndex].isCorrect
        return AnswerExplanationViewModel(
            isCorrect: isCorrect,
            explanation: task.explanation,
            correctAnswer: isCorrect ? nil : correctAnswerText(in: answers)
        )
    }

    private func correctAnswerText(in answers: [PracticeAnswer]) -> String? {
        answers.first { $0.isCorrect }?.text
    }
}
