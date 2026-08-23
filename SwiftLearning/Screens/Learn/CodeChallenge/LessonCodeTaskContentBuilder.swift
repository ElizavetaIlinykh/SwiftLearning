import Foundation

struct LessonCodeTaskContentContext {
    let codeTaskState: LessonCodeTaskLoadingState
    let answerState: AnswerState
}

struct LessonCodeTaskContentBuilder {
    // MARK: - Public methods -

    func build(
        context: LessonCodeTaskContentContext
    ) -> LessonCodeTaskContentViewModel? {
        guard case let .loaded(codeTask) = context.codeTaskState else {
            return nil
        }

        return LessonCodeTaskContentViewModel(
            title: codeTask.title,
            description: codeTask.description,
            codeSectionTitle: codeSectionTitle(answerState: context.answerState),
            code: codeTask.code
        )
    }

    // MARK: - Private methods -

    private func codeSectionTitle(answerState: AnswerState) -> String {
        answerState == .correct ? "COMPLETED CODE" : "COMPLETE THE CODE"
    }
}
