import Combine
import Foundation

enum LessonsMoreLoadingState: Equatable {
    case idle
    case loading
    case failed(String)
}

enum LessonsLoadingState: Equatable {
    case idle
    case loading
    case loaded(
        lessons: [LessonSummary],
        moreLoadingState: LessonsMoreLoadingState
    )
    case failed(String)
}

@MainActor
final class LearnViewModel: ObservableObject {
    // MARK: - Private properties -

    private let lessonsManager: LessonsManager
    private let lessonCardBuilder: LearnLessonCardBuilder
    private let progressCardBuilder: LearnProgressCardBuilder
    private let router: AppRouter

    // MARK: - Public properties -

    @Published private(set) var state: LessonsLoadingState = .idle

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
    }

    // MARK: - Public methods -

    func fetchLessons() async {
        if lessons.isEmpty {
            state = .loading
        }

        do {
            let lessons = try await lessonsManager.fetch()
            setLoadedState(lessons: lessons)
        } catch is CancellationError {
            return
        } catch {
            state = .failed(
                UserFacingErrorMessage.message(for: error)
            )
        }
    }

    func loadMoreLessons() async {
        setLoadMoreState(.loading)

        do {
            let lessons = try await lessonsManager.loadMore()
            setLoadedState(lessons: lessons)
        } catch is CancellationError {
            setLoadMoreState(.idle)
        } catch {
            setLoadMoreState(
                .failed(
                    UserFacingErrorMessage.message(for: error)
                )
            )
        }
    }

    func retryLoadMoreLessons() async {
        await loadMoreLessons()
    }

    func refreshLessons() async {
        do {
            let lessons = try await lessonsManager.refresh()
            setLoadedState(lessons: lessons)
        } catch is CancellationError {
            return
        } catch {
            state = .failed(
                UserFacingErrorMessage.message(for: error)
            )
        }
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

    private func setLoadedState(
        lessons: [LessonSummary],
        moreLoadingState: LessonsMoreLoadingState = .idle
    ) {
        state = .loaded(
            lessons: lessons,
            moreLoadingState: moreLoadingState
        )
    }

    private func setLoadMoreState(_ moreLoadingState: LessonsMoreLoadingState) {
        guard case let .loaded(lessons, _) = state else {
            return
        }

        setLoadedState(
            lessons: lessons,
            moreLoadingState: moreLoadingState
        )
    }

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
}
