import Foundation

struct LessonQuizQuestion: Hashable, Decodable, Identifiable {
    let id: UUID
    let text: String
    let order: Int
    let answers: [LessonQuizAnswer]
}

struct LessonQuizAnswer: Hashable, Decodable, Identifiable {
    let id: UUID
    let text: String
    let order: Int
    let isCorrect: Bool
}
