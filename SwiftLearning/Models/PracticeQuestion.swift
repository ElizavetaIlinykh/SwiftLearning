import Foundation

struct PracticeQuestion: Identifiable, Hashable {
    let id: String
    let question: String
    let code: String?
    let answers: [String]
    let correctAnswerIndex: Int
    let explanation: String
}
