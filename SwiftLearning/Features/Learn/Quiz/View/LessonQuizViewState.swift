import Foundation

struct LessonQuizContentViewData {
    let question: LessonQuizQuestionViewData
    let progressTitle: String
    let progressValue: Double
    let isAnswered: Bool
    let primaryButtonTitle: String
    let answerExplanationViewData: AnswerExplanationViewData?
}

struct LessonQuizQuestionViewData: Identifiable {
    let id: UUID
    let text: String
    let explanation: String
    let difficulty: Difficulty
    let tags: [String]
    let answers: [LessonQuizAnswerViewData]
}

struct LessonQuizAnswerViewData: Identifiable {
    let id: UUID
    let text: String
    let isCorrect: Bool
    let state: AnswerOptionState
}

enum LessonQuizViewState {
    case loading
    case content(LessonQuizContentViewData)
    case empty
    case error(String)
}
