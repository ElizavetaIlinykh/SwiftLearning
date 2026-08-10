import Foundation

struct LessonDetails: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let description: String
    let order: Int
    let theory: String
    let codeExample: String
}
