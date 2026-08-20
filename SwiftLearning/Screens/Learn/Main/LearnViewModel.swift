import Combine
import Foundation

@MainActor
final class LearnViewModel: ObservableObject {
    // MARK: - Private properties -

    private let lessonsManager: LessonsManager
    private let lessonCardBuilder: LearnLessonCardBuilder
    private let progressCardBuilder: LearnProgressCardBuilder
    private let router: AppRouter
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public properties -

    @Published private(set) var state: LessonsLoadingState
    var lessons: [LessonSummary] {
        guard case let .loaded(lessons, _) = state else { return [] }
        return lessons
    }

    var lessonCards: [LessonCardViewModel] {
        lessonCardBuilder.build(lessons: lessons)
    }

    var progressCard: ProgressCardViewModel {
        progressCardBuilder.build(
            lessons: lessons,
            action: continueLearningAction
        )
    }

    var completedLessonsCount: Int {
        lessons.filter { $0.status == .completed }.count
    }

    var nextAvailableLesson: LessonSummary? {
        lessons
            .sorted { $0.order < $1.order }
            .first { $0.status == .available }
    }

    var loadMoreState: LoadMoreView.State {
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

    // MARK: - Init -

    init(
        lessonsManager: LessonsManager,
        lessonCardBuilder: LearnLessonCardBuilder,
        progressCardBuilder: LearnProgressCardBuilder,
        router: AppRouter
    ) {
        self.lessonsManager = lessonsManager
        self.lessonCardBuilder = lessonCardBuilder
        self.progressCardBuilder = progressCardBuilder
        self.router = router
        state = lessonsManager.state

        bindLessonsManager()
    }

    // MARK: - Public methods -

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

    func selectLesson(id: String) {
        openLesson(id: id)
    }

    // MARK: - Private properties -

    private var continueLearningAction: (() -> Void)? {
        guard nextAvailableLesson != nil else {
            return nil
        }

        return continueLearning
    }

    // MARK: - Private methods -

    private func continueLearning() {
        guard let lesson = nextAvailableLesson else {
            return
        }

        openLesson(id: lesson.id)
    }

    private func openLesson(id: String) {
        router.push(
            .lesson(
                id: id,
                totalLessonsCount: lessons.count
            )
        )
    }

    private func bindLessonsManager() {
        lessonsManager.$state
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)
    }
}
