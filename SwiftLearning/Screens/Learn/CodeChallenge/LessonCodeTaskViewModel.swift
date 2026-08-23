import Combine
import Foundation

@MainActor
final class LessonCodeTaskViewModel: ObservableObject {
    // MARK: - Private properties -

    private let codeTaskManager: LessonCodeTaskManager
    private let completionViewModel: LessonCompletionViewModel
    private let router: AppRouter

    // MARK: - Public properties -

    let lessonID: String
    @Published private(set) var codeTaskState: LessonCodeTaskLoadingState = .idle
    @Published private(set) var completionState: LessonCompletionViewModel.State = .idle

    // MARK: - Init -

    init(
        lessonID: String,
        codeTaskManager: LessonCodeTaskManager,
        completionViewModel: LessonCompletionViewModel,
        router: AppRouter
    ) {
        self.lessonID = lessonID
        self.codeTaskManager = codeTaskManager
        self.completionViewModel = completionViewModel
        self.router = router
    }

    // MARK: - Public methods -

    func loadCodeTask() async {
        codeTaskState = .loading

        do {
            let codeTask = try await codeTaskManager.loadCodeTask()
            codeTaskState = .loaded(codeTask)
        } catch is CancellationError {
            return
        } catch LessonCodeTaskError.notFound {
            codeTaskState = .notAvailable
        } catch {
            codeTaskState = .failed(UserFacingErrorMessage.message(for: error))
        }
    }

    func isCorrectAnswer(_ answer: String, for codeTask: LessonCodeTask) -> Bool {
        answer.trimmingCharacters(in: .whitespacesAndNewlines) == codeTask.correctAnswer
    }

    func completeLesson() async -> Bool {
        completionState = .completing
        let didComplete = await completionViewModel.completeLesson()
        completionState = completionViewModel.state
        return didComplete
    }

    func openResult() {
        router.push(.result(lessonID: lessonID))
    }
}
