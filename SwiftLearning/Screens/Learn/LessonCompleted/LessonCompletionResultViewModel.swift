import Foundation

@MainActor
final class LessonCompletionResultViewModel {
    // MARK: - Private properties -

    private let onContinueLearning: () -> Void

    // MARK: - Public properties -

    let lessonID: String

    // MARK: - Init -

    init(
        lessonID: String,
        onContinueLearning: @escaping () -> Void
    ) {
        self.lessonID = lessonID
        self.onContinueLearning = onContinueLearning
    }

    // MARK: - Public methods -

    func continueLearning() {
        onContinueLearning()
    }
}
