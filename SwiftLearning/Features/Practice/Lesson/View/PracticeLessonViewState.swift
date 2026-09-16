import Foundation

struct PracticeLessonContentViewData {
    let topicTitle: String
    let task: PracticeTaskViewData
    let progressTitle: String
    let progressValue: Double
    let isAnswered: Bool
    let actionButtonTitle: String
    let isActionButtonDisabled: Bool
    let answerExplanationViewData: AnswerExplanationViewData?
    let paginationErrorMessage: String?
}

struct PracticeTaskViewData: Identifiable {
    let id: String
    let question: String
    let code: String?
    let explanation: String
    let difficulty: Difficulty
    let tags: [String]
    let answers: [PracticeAnswerViewData]
}

struct PracticeAnswerViewData: Identifiable {
    let id: String
    let text: String
    let isCorrect: Bool
    let state: AnswerOptionState
}

enum PracticeLessonViewState {
    case loading
    case content(PracticeLessonContentViewData)
    case empty
    case error(String)
}
