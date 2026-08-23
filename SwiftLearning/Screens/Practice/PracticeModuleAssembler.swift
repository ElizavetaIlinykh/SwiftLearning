import SwiftUI

@MainActor
enum PracticeModuleAssembler {
    // MARK: - Public methods -

    static func assemble(
        dependencies: AppDependencies,
        onOpenTopic: @escaping (String, String) -> Void
    ) -> PracticeView {
        let topicsManager = PracticeTopicsManager(practiceService: dependencies.services.practiceService)
        let viewModel = PracticeViewModel(
            topicsManager: topicsManager,
            categoryCardBuilder: PracticeCategoryCardBuilder(),
            onOpenTopic: onOpenTopic
        )

        return PracticeView(viewModel: viewModel)
    }

    static func assembleSession(
        topicID: String,
        topicTitle: String,
        dependencies: AppDependencies,
        onClosePractice: @escaping () -> Void,
        onOpenResult: @escaping (PracticeProgress) -> Void
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
            onClosePractice: onClosePractice,
            onOpenResult: onOpenResult
        )

        return PracticeSessionView(viewModel: viewModel)
    }
}
