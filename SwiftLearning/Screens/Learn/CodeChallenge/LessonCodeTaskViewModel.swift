import Combine
import Foundation

@MainActor
final class LessonCodeTaskViewModel: ObservableObject {
    // MARK: - Private properties -

    private let codeTaskManager: LessonCodeTaskManager
    private let completionViewModel: LessonCompletionViewModel
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public properties -

    let lessonID: String

    // MARK: - Init -

    @Published private(set) var codeTaskState: LessonCodeTaskLoadingState
    @Published private(set) var completionState: LessonCompletionViewModel.State
    init(
        lessonID: String,
        codeTaskManager: LessonCodeTaskManager,
        completionViewModel: LessonCompletionViewModel
    ) {
        self.lessonID = lessonID
        self.codeTaskManager = codeTaskManager
        self.completionViewModel = completionViewModel
        codeTaskState = codeTaskManager.state
        completionState = completionViewModel.state

        bindManagers()
    }

    // MARK: - Public methods -

    func loadCodeTask() async {
        await codeTaskManager.loadCodeTask()
    }

    func isCorrectAnswer(_ answer: String, for codeTask: LessonCodeTask) -> Bool {
        answer.trimmingCharacters(in: .whitespacesAndNewlines) == codeTask.correctAnswer
    }

    func completeLesson() async -> Bool {
        await completionViewModel.completeLesson()
    }

    // MARK: - Private methods -

    private func bindManagers() {
        codeTaskManager.$state
            .sink { [weak self] codeTaskState in
                self?.codeTaskState = codeTaskState
            }
            .store(in: &cancellables)

        completionViewModel.$state
            .sink { [weak self] completionState in
                self?.completionState = completionState
            }
            .store(in: &cancellables)
    }
}
