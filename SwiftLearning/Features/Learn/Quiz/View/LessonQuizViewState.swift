import Foundation

struct LessonQuizContentViewModel {
    let question: LessonQuizQuestionViewModel
    let progressTitle: String
    let progressValue: Double
    let isAnswered: Bool
    let primaryButtonTitle: String
    let answerExplanationViewModel: AnswerExplanationViewModel?
}

struct LessonQuizQuestionViewModel: Identifiable {
    let id: UUID
    let text: String
    let explanation: String
    let difficulty: Difficulty
    let tags: [String]
    let answers: [LessonQuizAnswerViewModel]
}

struct LessonQuizAnswerViewModel: Identifiable {
    let id: UUID
    let text: String
    let isCorrect: Bool
    let state: AnswerOptionState
}

enum LessonQuizViewState {
    case loading
    case content(LessonQuizContentViewModel)
    case empty
    case error(String)
}
