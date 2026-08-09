import Foundation

struct Lesson: Identifiable, Hashable, Codable {
    let id: Int
    let title: String
    let duration: String
    let theoryTitle: String
    let theoryText: String
    let codeExample: String
    let explanation: String
    let quiz: QuizQuestion
    let challenge: CodeChallenge
}

struct QuizQuestion: Hashable, Codable {
    let question: String
    let answers: [String]
    let correctAnswerIndex: Int
    let explanation: String
}

struct CodeChallenge: Hashable, Codable {
    let title: String
    let description: String
    let codeTemplate: String
    let options: [String]
    let correctAnswerIndex: Int
    let completedCode: String
}
