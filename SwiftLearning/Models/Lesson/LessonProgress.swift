import Foundation

struct LessonProgress: Decodable, Hashable {
    // MARK: - Public properties -

    let lessonId: UUID
    let status: LessonStatus
    let completedAt: Date?
}
