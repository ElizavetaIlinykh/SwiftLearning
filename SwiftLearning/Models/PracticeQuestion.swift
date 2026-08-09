import Foundation

struct PracticeQuestion: Identifiable, Hashable, Codable {
    let id: String
    let question: String
    let code: String?
    let answers: [String]
    let correctAnswerIndex: Int
    let explanation: String
}
