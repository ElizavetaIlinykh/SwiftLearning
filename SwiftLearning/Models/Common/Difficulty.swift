import Foundation

enum Difficulty: String, Codable, Hashable, Sendable {
    case easy
    case medium
    case hard
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).lowercased()
        self = Difficulty(rawValue: value) ?? .unknown
    }
}
