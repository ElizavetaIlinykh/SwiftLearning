import Foundation

enum LessonCompletionResultOutput {
    case continueLearning
}

@MainActor
final class LessonCompletionResultViewModel {
    // MARK: - Private properties -

    private let output: (LessonCompletionResultOutput) -> Void

    // MARK: - Public properties -

    let lessonID: String

    // MARK: - Init -

    init(
        lessonID: String,
        output: @escaping (LessonCompletionResultOutput) -> Void
    ) {
        self.lessonID = lessonID
        self.output = output
    }

    // MARK: - Public methods -

    func continueLearning() {
        output(.continueLearning)
    }
}
