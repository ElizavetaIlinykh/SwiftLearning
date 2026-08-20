import SwiftUI

@MainActor
enum LearnModuleAssembler {
    // MARK: - Public methods -

    static func assemble(
        dependencies: AppDependencies,
        router: AppRouter
    ) -> LearnView {
        let lessonsManager = LessonsManager(lessonsService: dependencies.services.lessonsService)
        let lessonCardBuilder = LearnLessonCardBuilder()
        let progressCardBuilder = LearnProgressCardBuilder()
        let viewModel = LearnViewModel(
            lessonsManager: lessonsManager,
            lessonCardBuilder: lessonCardBuilder,
            progressCardBuilder: progressCardBuilder,
            router: router
        )

        return LearnView(viewModel: viewModel)
    }
}
