import Combine
import Foundation

@MainActor
final class LearnViewModel: ObservableObject {
    private let lessonsManager: LessonsManager
    private var cancellables: Set<AnyCancellable> = []

    @Published private(set) var state: LessonsLoadingState
    @Published private(set) var isLoadingMore: Bool
    @Published private(set) var loadMoreError: String?
    @Published private(set) var canRequestMoreLessons: Bool

    var lessons: [LessonSummary] {
        guard case .loaded(let lessons) = state else { return [] }
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

    init(lessonsManager: LessonsManager) {
        self.lessonsManager = lessonsManager
        self.state = lessonsManager.state
        self.isLoadingMore = lessonsManager.isLoadingMore
        self.loadMoreError = lessonsManager.loadMoreError
        self.canRequestMoreLessons = lessonsManager.canFetchMoreLessons

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

        lessonsManager.$isLoadingMore
            .sink { [weak self] isLoadingMore in
                self?.isLoadingMore = isLoadingMore
            }
            .store(in: &cancellables)

        lessonsManager.$loadMoreError
            .sink { [weak self] loadMoreError in
                self?.loadMoreError = loadMoreError
            }
            .store(in: &cancellables)

        lessonsManager.$canFetchMoreLessons
            .sink { [weak self] canFetchMoreLessons in
                self?.canRequestMoreLessons = canFetchMoreLessons
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
