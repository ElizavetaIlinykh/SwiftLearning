import Combine
import Foundation

@MainActor
final class LessonCodeTaskViewModel: ObservableObject {
    // MARK: - Private properties -

    private let codeTaskManager: LessonCodeTaskManager
    private let builders: LessonCodeTaskBuilders
    private let router: AppRouter

    // MARK: - Public properties -

    let lessonID: String
    @Published var answer = ""
    @Published private(set) var codeTaskState: LessonCodeTaskLoadingState = .idle
    @Published private(set) var completionState: LessonCompletionState = .idle
    @Published private(set) var answerState: AnswerState = .idle

    var codeTaskContentViewModel: LessonCodeTaskContentViewModel? {
        builders.contentBuilder.build(context: codeTaskContentContext)
    }

    var primaryButtonViewModel: LessonCodeTaskPrimaryButtonViewModel {
        builders.primaryButtonBuilder.build(context: primaryButtonContext)
    }

    // MARK: - Init -

    init(
        lessonID: String,
        codeTaskManager: LessonCodeTaskManager,
        builders: LessonCodeTaskBuilders,
        router: AppRouter
    ) {
        self.lessonID = lessonID
        self.codeTaskManager = codeTaskManager
        self.builders = builders
        self.router = router
    }

    // MARK: - Public methods -

    func loadCodeTask() async {
        codeTaskState = .loading
        resetAnswer()

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

    func performPrimaryAction(_ action: LessonCodeTaskPrimaryAction) async {
        switch action {
        case .checkAnswer:
            checkCurrentAnswer()
        case .finishLesson:
            await finishLesson()
        }
    }

    // MARK: - Private methods -

    private var codeTaskContentContext: LessonCodeTaskContentContext {
        LessonCodeTaskContentContext(
            codeTaskState: codeTaskState,
            answerState: answerState
        )
    }

    private var primaryButtonContext: LessonCodeTaskPrimaryButtonContext {
        LessonCodeTaskPrimaryButtonContext(
            codeTaskState: codeTaskState,
            answerState: answerState,
            completionState: completionState
        )
    }

    private func checkCurrentAnswer() {
        guard case let .loaded(codeTask) = codeTaskState else {
            return
        }

        answerState = isCorrectAnswer(answer, for: codeTask) ? .correct : .incorrect
    }

    private func finishLesson() async {
        await completeLesson()
    }

    private func completeLesson() async {
        guard completionState != .completing else {
            return
        }

        completionState = .completing

        do {
            let progress = try await codeTaskManager.completeLesson()
            completionState = .completed(progress)
            openResult()
        } catch is CancellationError {
            return
        } catch {
            completionState = .failed(UserFacingErrorMessage.message(for: error))
        }
    }

    private func openResult() {
        router.push(.result(lessonID: lessonID))
    }

    private func resetAnswer() {
        answer = ""
        answerState = .idle
    }

    private func isCorrectAnswer(_ answer: String, for codeTask: LessonCodeTask) -> Bool {
        answer.trimmingCharacters(in: .whitespacesAndNewlines) == codeTask.correctAnswer
    }
}
