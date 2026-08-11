import Combine
import Foundation

@MainActor
final class LessonQuizViewModel: ObservableObject {
    private let quizManager: LessonQuizManager
    private var cancellables: Set<AnyCancellable> = []

    let lessonID: String

    var state: LessonQuizLoadingState {
        quizManager.state
    }

    init(
        lessonID: String,
        quizManager: LessonQuizManager
    ) {
        self.lessonID = lessonID
        self.quizManager = quizManager
        bindQuizManagerUpdates()
    }

    func loadQuestions() async {
        await quizManager.loadQuestions()
    }

    private func bindQuizManagerUpdates() {
        quizManager.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
