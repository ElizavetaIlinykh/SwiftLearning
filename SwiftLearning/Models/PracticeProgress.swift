import Foundation

struct PracticeProgress: Decodable, Hashable {
    let topicId: String
    let correctAnswersCount: Int
    let totalAnswersCount: Int
    let scorePercent: Int
    let completedAt: Date
}
