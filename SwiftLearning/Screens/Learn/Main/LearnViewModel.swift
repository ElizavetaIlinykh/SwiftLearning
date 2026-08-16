import Combine
import Foundation

@MainActor
final class LearnViewModel: ObservableObject {
    private let lessonsManager: LessonsManager
    private var cancellables: Set<AnyCancellable> = []

    @Published private(set) var state: LessonsLoadingState

    var lessons: [LessonSummary] {
        guard case .loaded(let lessons, _) = state else { return [] }
        return lessons
    }

    var lessonCards: [LessonCardViewModel] {
        lessons
            .sorted { $0.order < $1.order }
            .map { lesson in
                LessonCardViewModel(
                    id: lesson.id,
                    title: lesson.title,
                    description: lesson.description,
                    order: lesson.order,
                    state: lessonState(for: lesson.status)
                )
            }
    }

    var completedLessonsCount: Int {
        lessons.filter { $0.status == .completed }.count
    }

    var moreLoadingState: LessonsMoreLoadingState {
        guard case .loaded(_, let moreLoadingState) = state else { return .idle }
        return moreLoadingState
    }

    init(lessonsManager: LessonsManager) {
        self.lessonsManager = lessonsManager
        self.state = lessonsManager.state

        bindLessonsManager()
    }

    func loadLessons() async {
        await lessonsManager.loadLessons()
    }

    func loadMoreLessonsIfNeeded(currentLessonID: String) async {
        await lessonsManager.loadMoreLessonsIfNeeded(currentLessonID: currentLessonID)
    }

    func retryLoadMoreLessons() async {
        await lessonsManager.retryLoadMoreLessons()
    }

    private func bindLessonsManager() {
        lessonsManager.$state
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)
    }

    private func lessonState(for status: LessonStatus) -> LessonState {
        switch status {
        case .completed:
            return .completed
        case .available:
            return .current
        case .locked:
            return .locked
        }
    }
}
