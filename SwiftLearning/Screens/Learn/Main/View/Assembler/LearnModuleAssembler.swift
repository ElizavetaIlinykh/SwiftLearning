import SwiftUI

@MainActor
enum LearnModuleAssembler {
    // MARK: - Public methods -

    static func assemble(
        dependencies: AppDependencies,
        output: @escaping (LearnOutput) -> Void
    ) -> LearnView {
        let lessonsManager = LessonsManager(lessonsService: dependencies.services.lessonsService)
        let lessonCardBuilder = LearnLessonCardBuilder()
        let progressCardBuilder = LearnProgressCardBuilder()
        let viewModel = LearnViewModel(
            lessonsManager: lessonsManager,
            lessonCardBuilder: lessonCardBuilder,
            progressCardBuilder: progressCardBuilder,
            output: output
        )

        return LearnView(viewModel: viewModel)
    }
}
