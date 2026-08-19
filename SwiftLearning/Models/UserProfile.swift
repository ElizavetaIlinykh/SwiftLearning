import Foundation

struct UserProfile: Decodable, Hashable, Identifiable {
    // MARK: - Public properties -

    let id: String
    let email: String
    let name: String
    let level: Int
    let completedLessonsCount: Int
    let createdAt: Date
}
