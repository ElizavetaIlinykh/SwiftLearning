import Combine
import Foundation

@MainActor
final class LessonQuizViewModel: ObservableObject {
    private let quizManager: LessonQuizManager
    private var cancellables: Set<AnyCancellable> = []

    let lessonID: String

    @Published private(set) var state: LessonQuizLoadingState

    init(
        lessonID: String,
        quizManager: LessonQuizManager
    ) {
        self.lessonID = lessonID
        self.quizManager = quizManager
        self.state = quizManager.state

        bindQuizManager()
    }

    func loadQuestions() async {
        await quizManager.loadQuestions()
    }

    private func bindQuizManager() {
        quizManager.$state
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)
    }
}
