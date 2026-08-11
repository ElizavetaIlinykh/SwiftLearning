import Combine
import Foundation

@MainActor
final class LessonCodeTaskViewModel: ObservableObject {
    private let codeTaskManager: LessonCodeTaskManager
    private let completionViewModel: LessonCompletionViewModel
    private var cancellables: Set<AnyCancellable> = []

    let lessonID: String

    var codeTaskState: LessonCodeTaskLoadingState {
        codeTaskManager.state
    }

    var completionState: LessonCompletionViewModel.State {
        completionViewModel.state
    }

    init(
        lessonID: String,
        codeTaskManager: LessonCodeTaskManager,
        completionViewModel: LessonCompletionViewModel
    ) {
        self.lessonID = lessonID
        self.codeTaskManager = codeTaskManager
        self.completionViewModel = completionViewModel
        bindManagers()
    }

    func loadCodeTask() async {
        await codeTaskManager.loadCodeTask()
    }

    func isCorrectAnswer(_ answer: String, for codeTask: LessonCodeTask) -> Bool {
        answer.trimmingCharacters(in: .whitespacesAndNewlines) == codeTask.correctAnswer
    }

    func completeLesson() async -> Bool {
        await completionViewModel.completeLesson()
    }

    private func bindManagers() {
        codeTaskManager.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)

        completionViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
