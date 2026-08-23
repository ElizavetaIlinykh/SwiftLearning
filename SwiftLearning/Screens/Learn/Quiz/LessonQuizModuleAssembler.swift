import SwiftUI

@MainActor
enum LessonQuizModuleAssembler {
    // MARK: - Public methods -

    static func assemble(
        lessonID: String,
        dependencies: AppDependencies,
        router: AppRouter
    ) -> LessonQuizRouteView {
        let quizManager = LessonQuizManager(
            lessonID: lessonID,
            lessonsService: dependencies.services.lessonsService
        )
        let viewModel = LessonQuizViewModel(
            lessonID: lessonID,
            quizManager: quizManager,
            router: router
        )

        return LessonQuizRouteView(viewModel: viewModel)
    }
}
