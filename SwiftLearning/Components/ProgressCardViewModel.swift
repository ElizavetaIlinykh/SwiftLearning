enum ProgressCardState {
    case notStarted
    case inProgress
    case completed
}

struct ProgressCardViewModel {
    // MARK: - Public properties -

    let courseTitle: String
    let completedLessonsTitle: String
    let completedLessonsCount: Int
    let totalLessonsCount: Int
    let progress: Double
    let state: ProgressCardState
}
