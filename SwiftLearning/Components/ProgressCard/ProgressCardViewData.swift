enum ProgressCardState {
    case notStarted
    case inProgress
    case completed
}

struct ProgressCardViewData {
    // MARK: - Public properties -

    let courseTitle: String
    let completedLessonsTitle: String
    let completedLessonsCount: Int
    let totalLessonsCount: Int
    let progress: Double
    let state: ProgressCardState
}
