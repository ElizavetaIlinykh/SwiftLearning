import Foundation

struct UserProfile: Decodable, Hashable, Identifiable {
    // MARK: - Public properties -

    let id: String
    let email: String
    let name: String
    let level: Int
    let completedLessonsCount: Int
    let createdAt: Date

    // MARK: - Init -

    init(
        id: String,
        email: String,
        name: String,
        level: Int = 1,
        completedLessonsCount: Int = 0,
        createdAt: Date
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.level = level
        self.completedLessonsCount = completedLessonsCount
        self.createdAt = createdAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        name = try container.decode(String.self, forKey: .name)
        level = try container.decodeIfPresent(Int.self, forKey: .level) ?? 1
        completedLessonsCount = try container.decodeIfPresent(Int.self, forKey: .completedLessonsCount) ?? 0
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case level
        case completedLessonsCount
        case createdAt
    }
}
