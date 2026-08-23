import SwiftUI

@MainActor
enum LearnModuleAssembler {
    // MARK: - Public methods -

    static func assemble(
        dependencies: AppDependencies,
        onOpenLesson: @escaping (String, Int) -> Void
    ) -> LearnView {
        let lessonsManager = LessonsManager(lessonsService: dependencies.services.lessonsService)
        let lessonCardBuilder = LearnLessonCardBuilder()
        let progressCardBuilder = LearnProgressCardBuilder()
        let viewModel = LearnViewModel(
            lessonsManager: lessonsManager,
            lessonCardBuilder: lessonCardBuilder,
            progressCardBuilder: progressCardBuilder,
            onOpenLesson: onOpenLesson
        )

        return LearnView(viewModel: viewModel)
    }
}
