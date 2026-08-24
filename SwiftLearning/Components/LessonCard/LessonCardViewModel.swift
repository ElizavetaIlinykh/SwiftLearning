enum LessonState {
    case completed
    case current
    case locked
}

struct LessonCardViewModel: Identifiable, Hashable {
    // MARK: - Public properties -

    let id: String
    let title: String
    let description: String
    let order: Int
    let state: LessonState
    let actionTitle: String
}
