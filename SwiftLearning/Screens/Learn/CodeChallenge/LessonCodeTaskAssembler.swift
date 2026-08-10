import SwiftUI

@MainActor
enum LessonCodeTaskAssembler {
    static func assemble(
        lessonID: String,
        dependencies: AppDependencies
    ) -> LessonCodeTaskView {
        let viewModel = LessonCompletionViewModel(
            lessonID: lessonID,
            lessonsService: dependencies.services.lessonsService
        )

        return LessonCodeTaskView(
            lessonID: lessonID,
            viewModel: viewModel
        )
    }
}
