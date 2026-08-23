import SwiftUI

@MainActor
enum LessonModuleAssembler {
    // MARK: - Public methods -

    static func assemble(
        lessonID: String,
        totalLessonsCount: Int,
        dependencies: AppDependencies,
        router: AppRouter
    ) -> LessonView {
        let lessonDetailsManager = LessonDetailsManager(
            lessonID: lessonID,
            lessonsService: dependencies.services.lessonsService
        )
        let builders = LessonBuilders(
            progressBuilder: LessonProgressBuilder(),
            contentBuilder: LessonContentBuilder()
        )
        let viewModel = LessonViewModel(
            lessonDetailsManager: lessonDetailsManager,
            totalLessonsCount: totalLessonsCount,
            builders: builders,
            router: router
        )

        return LessonView(viewModel: viewModel)
    }
}
