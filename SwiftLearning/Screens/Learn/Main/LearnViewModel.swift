import Combine
import Foundation

@MainActor
final class LearnViewModel: ObservableObject {
    enum LoadMoreState {
        case idle
        case loading
        case error(String)
    }

    private let lessonsManager: LessonsManager
    private var cancellables: Set<AnyCancellable> = []

    @Published private(set) var state: LessonsLoadingState

    var lessons: [LessonSummary] {
        guard case let .loaded(lessons, _) = state else { return [] }
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

    var loadMoreState: LoadMoreState {
        guard case let .loaded(_, moreLoadingState) = state else { return .idle }
        switch moreLoadingState {
        case .loading:
            return .loading
        case let .failed(message):
            return .error(message)
        case .idle:
            return .idle
        }
    }

    init(lessonsManager: LessonsManager) {
        self.lessonsManager = lessonsManager
        state = lessonsManager.state

        bindLessonsManager()
    }

    func fetchLessons() async {
        await lessonsManager.fetch()
    }

    func loadMoreLessons() async {
        await lessonsManager.loadMore()
    }

    func retryLoadMoreLessons() async {
        await lessonsManager.loadMore()
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
            .completed
        case .available:
            .current
        case .locked:
            .locked
        }
    }
}
