import Foundation

struct PracticeSessionContentViewModel {
    let task: PracticeTaskViewModel
    let progressTitle: String
    let progressValue: Double
    let isAnswered: Bool
    let actionButtonTitle: String
    let isActionButtonDisabled: Bool
    let answerExplanationViewModel: AnswerExplanationViewModel?
    let isLoadingMoreTasks: Bool
    let loadMoreTasksError: String?
}

struct PracticeTaskViewModel: Identifiable {
    let id: String
    let question: String
    let code: String?
    let explanation: String
    let difficulty: Difficulty
    let tags: [String]
    let answers: [PracticeAnswerViewModel]
}

struct PracticeAnswerViewModel: Identifiable {
    let id: String
    let text: String
    let isCorrect: Bool
    let state: AnswerOptionState
}

enum PracticeSessionViewState {
    case loading
    case content(PracticeSessionContentViewModel)
    case empty
    case error(String)
}
