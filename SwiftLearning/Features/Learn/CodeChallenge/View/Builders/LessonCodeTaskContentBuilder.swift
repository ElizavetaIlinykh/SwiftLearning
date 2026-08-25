import Foundation

struct LessonCodeTaskContentContext {
    let codeTask: LessonCodeTask
    let answerState: AnswerState
}

struct LessonCodeTaskContentBuilder {
    // MARK: - Public methods -

    func build(
        context: LessonCodeTaskContentContext
    ) -> LessonCodeTaskContentViewModel {
        LessonCodeTaskContentViewModel(
            title: context.codeTask.title,
            description: context.codeTask.description,
            codeSectionTitle: codeSectionTitle(answerState: context.answerState),
            code: context.codeTask.code
        )
    }

    // MARK: - Private methods -

    private func codeSectionTitle(answerState: AnswerState) -> String {
        answerState == .correct ? "COMPLETED CODE" : "COMPLETE THE CODE"
    }
}
