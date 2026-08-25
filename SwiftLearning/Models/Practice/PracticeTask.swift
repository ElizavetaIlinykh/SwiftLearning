import Foundation

struct PracticeTask: Identifiable, Hashable, INetworkEntity, Sendable {
    // MARK: - Public properties -

    let id: String
    let question: String
    let code: String?
    let order: Int
    let answers: [PracticeAnswer]
}

struct PracticeAnswer: Identifiable, Hashable, Codable, Sendable {
    // MARK: - Public properties -

    let id: String
    let text: String
    let order: Int
    let isCorrect: Bool
}
