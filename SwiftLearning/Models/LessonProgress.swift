import Foundation

struct LessonProgress: Decodable, Hashable {
    let lessonId: UUID
    let status: LessonStatus
    let completedAt: Date?
}
