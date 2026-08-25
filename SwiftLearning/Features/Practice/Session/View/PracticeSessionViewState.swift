import Foundation

struct PracticeSessionContentViewModel {
    let tasks: [PracticeTaskViewModel]
}

struct PracticeTaskViewModel: Identifiable {
    let id: String
    let question: String
    let code: String?
    let answers: [PracticeAnswerViewModel]
}

struct PracticeAnswerViewModel: Identifiable {
    let id: String
    let text: String
    let isCorrect: Bool
}

enum PracticeSessionViewState {
    case loading
    case content(PracticeSessionContentViewModel)
    case empty
    case error(String)
}
