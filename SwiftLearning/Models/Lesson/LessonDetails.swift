import Foundation

struct LessonDetails: Identifiable, Hashable, Codable {
    // MARK: - Public properties -

    let id: String
    let title: String
    let description: String?
    let order: Int
    let theory: String?
    let codeExample: String?
}
