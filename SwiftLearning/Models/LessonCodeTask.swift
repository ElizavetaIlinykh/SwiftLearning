import Foundation

struct LessonCodeTask: Decodable, Hashable, Identifiable {
    // MARK: - Public properties -

    let id: String
    let title: String
    let description: String
    let code: String
    let correctAnswer: String
}
