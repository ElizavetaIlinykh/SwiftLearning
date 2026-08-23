import Combine
import Foundation

@MainActor
final class LearnViewModel: ObservableObject {
    // MARK: - Private properties -

    private let lessonsManager: LessonsManager
    private let lessonCardBuilder: LearnLessonCardBuilder
    private let progressCardBuilder: LearnProgressCardBuilder
    private let router: AppRouter
    private var lessons: [LessonSummary] = []

    // MARK: - Public properties -

    @Published private(set) var state: LearnViewState = .loading

    var lessonCards: [LessonCardViewModel] {
        lessonCardBuilder.build(lessons: sortedLessons)
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
            lessons = try await lessonsManager.fetch()
            updateStateFromLessons()
        } catch is CancellationError {
            return
        } catch {
            state = .error(UserFacingErrorMessage.message(for: error))
        }
    }

    func loadMoreLessons() async {
        updateContentState(loadMoreState: .loading)

        do {
            lessons = try await lessonsManager.loadMore()
            updateStateFromLessons()
        } catch is CancellationError {
            updateStateFromLessons()
        } catch {
            updateStateFromLessons()
        }
    }

    func retryLoadMoreLessons() async {
        await loadMoreLessons()
    }

    func refreshLessons() async {
        do {
            lessons = try await lessonsManager.refresh()
            updateStateFromLessons()
        } catch is CancellationError {
            return
        } catch {
            state = .error(UserFacingErrorMessage.message(for: error))
        }
    }

    func selectLesson(id: String) {
        openLesson(id: id)
    }

    // MARK: - Private properties -

    private var sortedLessons: [LessonSummary] {
        lessons.sorted { $0.order < $1.order }
    }

    private var nextAvailableLesson: LessonSummary? {
        sortedLessons.first { $0.status == .available }
    }

    private var continueLearningAction: (() -> Void)? {
        guard nextAvailableLesson != nil else {
            return nil
        }

        return continueLearning
    }

    private var loadMoreState: LoadMoreView.State {
        switch lessonsManager.moreLoadingState {
        case .loading:
            .loading
        case let .failed(error):
            .error(UserFacingErrorMessage.message(for: error))
        case .idle:
            .idle
        }
    }

    // MARK: - Private methods -

    private func updateStateFromLessons() {
        if lessons.isEmpty {
            state = .empty
        } else {
            state = .content(makeContentViewModel())
        }
    }

    private func makeContentViewModel(
        loadMoreState: LoadMoreView.State? = nil
    ) -> LearnContentViewModel {
        LearnContentViewModel(
            progressCard: progressCardBuilder.build(
                lessons: sortedLessons,
                action: continueLearningAction
            ),
            lessonCards: lessonCards,
            loadMoreState: loadMoreState ?? self.loadMoreState
        )
    }

    private func updateContentState(loadMoreState: LoadMoreView.State) {
        guard case .content = state else {
            return
        }

        state = .content(
            makeContentViewModel(loadMoreState: loadMoreState)
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
