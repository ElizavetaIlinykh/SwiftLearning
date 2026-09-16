import Combine
import Foundation

enum LessonOutput {
    case openQuiz(lessonID: String)
}

@MainActor
final class LessonViewModel: ObservableObject {
    // MARK: - Private properties -

    private let lessonDetailsManager: LessonDetailsManager
    private let totalLessonsCount: Int
    private let builders: LessonBuilders
    private let output: (LessonOutput) -> Void

    // MARK: - Public properties -

    @Published private(set) var state: LessonViewState = .loading

    var navigationTitle: String {
        guard case let .content(_, contentViewData) = state else { return L10n.string("lesson.navigationTitle") }
        return contentViewData.title
    }

    // MARK: - Init -

    init(
        lessonDetailsManager: LessonDetailsManager,
        totalLessonsCount: Int,
        builders: LessonBuilders,
        output: @escaping (LessonOutput) -> Void
    ) {
        self.lessonDetailsManager = lessonDetailsManager
        self.totalLessonsCount = totalLessonsCount
        self.builders = builders
        self.output = output
    }

    // MARK: - Public methods -

    func loadLesson() async {
        state = .loading

        do {
            let lesson = try await lessonDetailsManager.loadLesson()
            state = makeContentState(lesson: lesson)
        } catch is CancellationError {
            return
        } catch {
            state = .error(UserFacingErrorMessage.message(for: error))
        }
    }

    func continueToQuiz(lessonID: String) {
        output(.openQuiz(lessonID: lessonID))
    }

    // MARK: - Private methods -

    private func makeContentState(lesson: LessonDetails) -> LessonViewState {
        .content(
            progressViewData: builders.progressBuilder.build(
                lesson: lesson,
                totalLessonsCount: totalLessonsCount
            ),
            contentViewData: builders.contentBuilder.build(lesson: lesson)
        )
    }
}
