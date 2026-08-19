import SwiftUI

@MainActor
enum LessonModuleAssembler {
    // MARK: - Public methods -

    static func assemble(
        lessonID: String,
        totalLessonsCount: Int,
        dependencies: AppDependencies
    ) -> LessonView {
        let lessonDetailsManager = LessonDetailsManager(
            lessonID: lessonID,
            lessonsService: dependencies.services.lessonsService
        )
        let viewModel = LessonViewModel(
            lessonDetailsManager: lessonDetailsManager,
            totalLessonsCount: totalLessonsCount
        )

        return LessonView(viewModel: viewModel)
    }
}
