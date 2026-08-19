import Foundation

struct LessonSummary: INetworkEntity {
    // MARK: - Public properties -

    let id: String
    let title: String
    let description: String
    let order: Int
    let status: LessonStatus
}

enum LessonStatus: String, INetworkEntity {
    case available
    case locked
    case completed
}
