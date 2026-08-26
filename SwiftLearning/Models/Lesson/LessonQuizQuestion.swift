import Foundation

struct LessonQuizQuestion: Hashable, Decodable, Identifiable {
    // MARK: - Public properties -

    let id: UUID
    let text: String
    let order: Int
    let explanation: String
    let difficulty: Difficulty
    let tags: [String]
    let answers: [LessonQuizAnswer]
}

struct LessonQuizAnswer: Hashable, Decodable, Identifiable {
    // MARK: - Public properties -

    let id: UUID
    let text: String
    let order: Int
    let isCorrect: Bool
}
