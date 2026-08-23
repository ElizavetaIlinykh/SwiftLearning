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
        let builders = LessonCodeTaskBuilders(
            contentBuilder: LessonCodeTaskContentBuilder(),
            primaryButtonBuilder: LessonCodeTaskPrimaryButtonBuilder()
        )
        let viewModel = LessonCodeTaskViewModel(
            lessonID: lessonID,
            codeTaskManager: codeTaskManager,
            builders: builders,
            router: router
        )

        return LessonCodeTaskView(viewModel: viewModel)
    }
}
