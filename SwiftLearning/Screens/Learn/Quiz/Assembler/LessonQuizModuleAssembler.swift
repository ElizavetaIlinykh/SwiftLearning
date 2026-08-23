import SwiftUI

@MainActor
enum LessonQuizModuleAssembler {
    // MARK: - Public methods -

    static func assemble(
        lessonID: String,
        dependencies: AppDependencies,
        output: @escaping (LessonQuizOutput) -> Void
    ) -> LessonQuizRouteView {
        let quizManager = LessonQuizManager(
            lessonID: lessonID,
            lessonsService: dependencies.services.lessonsService
        )
        let viewModel = LessonQuizViewModel(
            lessonID: lessonID,
            quizManager: quizManager,
            contentBuilder: LessonQuizContentBuilder(),
            output: output
        )

        return LessonQuizRouteView(viewModel: viewModel)
    }
}
