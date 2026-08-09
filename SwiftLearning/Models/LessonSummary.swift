import Foundation

struct LessonSummary: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let description: String
    let order: Int
    let status: LessonStatus
}

enum LessonStatus: String, Hashable, Codable {
    case available
    case locked
    case completed
}
