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
        guard case .loaded(_, let moreLoadingState) = state else {
            return .idle(canFetchMore: false)
        }
        return moreLoadingState
    }

    var isLoadingMore: Bool {
        moreLoadingState == .loading
    }

    var loadMoreError: String? {
        guard case .failed(let message) = moreLoadingState else { return nil }
        return message
    }

    var canRequestMoreLessons: Bool {
        guard case .idle(let canFetchMore) = moreLoadingState else { return false }
        return canFetchMore
    }

    init(lessonsManager: LessonsManager) {
        self.lessonsManager = lessonsManager
        self.state = lessonsManager.state

        bindLessonsManager()
    }

    func fetchLessons() async {
        await lessonsManager.fetch()
    }

    func refreshLessons() async {
        await lessonsManager.refresh()
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
