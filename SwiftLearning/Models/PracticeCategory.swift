import Foundation

struct PracticeCategory: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let description: String
    let systemImage: String
    let questions: [PracticeQuestion]
}
