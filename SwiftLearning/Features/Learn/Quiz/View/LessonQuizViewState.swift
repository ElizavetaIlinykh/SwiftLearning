import Foundation

struct LessonQuizContentViewModel {
    let questions: [LessonQuizQuestionViewModel]
}

struct LessonQuizQuestionViewModel: Identifiable {
    let id: UUID
    let text: String
    let answers: [LessonQuizAnswerViewModel]
}

struct LessonQuizAnswerViewModel: Identifiable {
    let id: UUID
    let text: String
    let isCorrect: Bool
}

enum LessonQuizViewState {
    case loading
    case content(LessonQuizContentViewModel)
    case empty
    case error(String)
}
