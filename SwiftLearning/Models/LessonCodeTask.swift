import Foundation

struct LessonCodeTask: Decodable, Hashable, Identifiable {
    let id: String
    let title: String
    let description: String
    let code: String
    let correctAnswer: String
}
