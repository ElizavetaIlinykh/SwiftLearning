import Foundation

struct Achievement: Identifiable, Hashable, Codable {
    // MARK: - Public properties -

    let id: String
    let title: String
    let description: String
    let systemImage: String
    let isUnlocked: Bool
}
