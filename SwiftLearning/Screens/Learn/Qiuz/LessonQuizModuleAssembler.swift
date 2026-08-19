import SwiftUI

@MainActor
enum LessonQuizModuleAssembler {
    // MARK: - Public methods -

    static func assemble(
        lessonID: String,
        dependencies: AppDependencies
    ) -> LessonQuizRouteView {
        let quizManager = LessonQuizManager(
            lessonID: lessonID,
            lessonsService: dependencies.services.lessonsService
        )
        let viewModel = LessonQuizViewModel(
            lessonID: lessonID,
            quizManager: quizManager
        )

        return LessonQuizRouteView(viewModel: viewModel)
    }
}
