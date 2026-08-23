import SwiftUI

@MainActor
enum LessonCodeTaskAssembler {
    // MARK: - Public methods -

    static func assemble(
        lessonID: String,
        dependencies: AppDependencies,
        router: AppRouter
    ) -> LessonCodeTaskView {
        let codeTaskManager = LessonCodeTaskManager(
            lessonID: lessonID,
            lessonsService: dependencies.services.lessonsService
        )
        let completionViewModel = LessonCompletionViewModel(
            lessonID: lessonID,
            lessonsService: dependencies.services.lessonsService
        )
        let viewModel = LessonCodeTaskViewModel(
            lessonID: lessonID,
            codeTaskManager: codeTaskManager,
            completionViewModel: completionViewModel,
            router: router
        )

        return LessonCodeTaskView(viewModel: viewModel)
    }
}
