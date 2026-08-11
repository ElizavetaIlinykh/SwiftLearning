import SwiftUI

@MainActor
enum LessonCodeTaskAssembler {
    static func assemble(
        lessonID: String,
        dependencies: AppDependencies
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
            completionViewModel: completionViewModel
        )

        return LessonCodeTaskView(viewModel: viewModel)
    }
}
