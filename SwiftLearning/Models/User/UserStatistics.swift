import Foundation

struct UserStatistics: Decodable, Hashable {
    // MARK: - Public properties -

    let completedLessonsCount: Int
    let totalLessonsCount: Int
    let progressPercent: Int
    let currentLevel: Int
    let completedPracticeTopicsCount: Int
}
