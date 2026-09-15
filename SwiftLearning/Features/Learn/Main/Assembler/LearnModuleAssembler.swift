import SwiftUI

@MainActor
enum LearnModuleAssembler {
    // MARK: - Public methods -

    static func assemble(
        dependencies: AppDependencies,
        output: @escaping (LearnOutput) -> Void
    ) -> LearnView {
        LearnView(
            viewModel: makeViewModel(
                dependencies: dependencies,
                output: output
            )
        )
    }

    static func makeViewModel(
        dependencies: AppDependencies,
        output: @escaping (LearnOutput) -> Void
    ) -> LearnViewModel {
        let lessonsManager = LessonsManager(lessonsService: dependencies.services.lessonsService)
        let lessonCardBuilder = LearnLessonCardBuilder()
        let progressCardBuilder = LearnProgressCardBuilder()

        return LearnViewModel(
            lessonsManager: lessonsManager,
            lessonCardBuilder: lessonCardBuilder,
            progressCardBuilder: progressCardBuilder,
            lessonProgressNotifier: dependencies.lessonProgressNotifier,
            output: output
        )
    }
}
