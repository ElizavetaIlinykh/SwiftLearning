import SwiftUI

@MainActor
enum PracticeModuleAssembler {
    // MARK: - Public methods -

    static func assemble(
        dependencies: AppDependencies,
        router: AppRouter
    ) -> PracticeView {
        let topicsManager = PracticeTopicsManager(practiceService: dependencies.services.practiceService)
        let viewModel = PracticeViewModel(
            topicsManager: topicsManager,
            categoryCardBuilder: PracticeCategoryCardBuilder(),
            router: router
        )

        return PracticeView(viewModel: viewModel)
    }

    static func assembleSession(
        topicID: String,
        topicTitle: String,
        dependencies: AppDependencies,
        router: AppRouter
    ) -> PracticeSessionView {
        let tasksManager = PracticeTasksManager(
            topicID: topicID,
            practiceService: dependencies.services.practiceService
        )
        let viewModel = PracticeSessionViewModel(
            topicID: topicID,
            topicTitle: topicTitle,
            tasksManager: tasksManager,
            taskBuilder: PracticeTaskBuilder(),
            practiceService: dependencies.services.practiceService,
            router: router
        )

        return PracticeSessionView(viewModel: viewModel)
    }
}
