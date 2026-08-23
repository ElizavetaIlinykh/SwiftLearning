import SwiftUI

@MainActor
enum LessonQuizModuleAssembler {
    // MARK: - Public methods -

    static func assemble(
        lessonID: String,
        dependencies: AppDependencies,
        onOpenCodeTask: @escaping (String) -> Void
    ) -> LessonQuizRouteView {
        let quizManager = LessonQuizManager(
            lessonID: lessonID,
            lessonsService: dependencies.services.lessonsService
        )
        let viewModel = LessonQuizViewModel(
            lessonID: lessonID,
            quizManager: quizManager,
            contentBuilder: LessonQuizContentBuilder(),
            onOpenCodeTask: onOpenCodeTask
        )

        return LessonQuizRouteView(viewModel: viewModel)
    }
}
