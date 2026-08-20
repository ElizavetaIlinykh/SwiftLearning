import Combine
import Foundation

@MainActor
final class LessonQuizViewModel: ObservableObject {
    // MARK: - Private properties -

    private let quizManager: LessonQuizManager
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public properties -

    let lessonID: String

    // MARK: - Init -

    @Published private(set) var state: LessonQuizLoadingState
    init(
        lessonID: String,
        quizManager: LessonQuizManager
    ) {
        self.lessonID = lessonID
        self.quizManager = quizManager
        state = quizManager.state

        bindQuizManager()
    }

    // MARK: - Public methods -

    func loadQuestions() async {
        await quizManager.loadQuestions()
    }

    // MARK: - Private methods -

    private func bindQuizManager() {
        quizManager.$state
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)
    }
}
