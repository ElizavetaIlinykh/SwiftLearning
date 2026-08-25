import Combine
import Foundation

enum LearnOutput {
    case openLesson(
        id: String,
        lessonsCount: Int
    )
}

@MainActor
final class LearnViewModel: ObservableObject {
    // MARK: - Private properties -

    private let lessonsManager: LessonsManager
    private let lessonCardBuilder: LearnLessonCardBuilder
    private let progressCardBuilder: LearnProgressCardBuilder
    private let output: (LearnOutput) -> Void
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
        output: @escaping (LearnOutput) -> Void
    ) {
        self.lessonsManager = lessonsManager
        self.lessonCardBuilder = lessonCardBuilder
        self.progressCardBuilder = progressCardBuilder
        self.output = output
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

    func handleProgressCardAction(_ action: ProgressCardAction) {
        switch action {
        case .startLearning, .continueLearning:
            continueLearning()
        }
    }

    // MARK: - Private properties -

    private var sortedLessons: [LessonSummary] {
        lessons.sorted { $0.order < $1.order }
    }

    private var nextAvailableLesson: LessonSummary? {
        sortedLessons.first { $0.status == .available }
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
            progressCard: progressCardBuilder.build(lessons: sortedLessons),
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
        output(
            .openLesson(
                id: id,
                lessonsCount: lessons.count
            )
        )
    }
}
