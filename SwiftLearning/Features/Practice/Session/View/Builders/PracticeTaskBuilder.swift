import Foundation

struct PracticeTaskBuilder {
    // MARK: - Public methods -

    func build(tasks: [PracticeTask]) -> [PracticeTaskViewModel] {
        tasks
            .sorted { $0.order < $1.order }
            .map(build(task:))
    }

    // MARK: - Private methods -

    private func build(task: PracticeTask) -> PracticeTaskViewModel {
        PracticeTaskViewModel(
            id: task.id,
            question: task.question,
            code: task.code,
            answers: task.answers
                .sorted { $0.order < $1.order }
                .map(build(answer:))
        )
    }

    private func build(answer: PracticeAnswer) -> PracticeAnswerViewModel {
        PracticeAnswerViewModel(
            id: answer.id,
            text: answer.text,
            isCorrect: answer.isCorrect
        )
    }
}
