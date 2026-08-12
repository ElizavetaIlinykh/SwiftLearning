import SwiftUI

@MainActor
enum PracticeModuleAssembler {
    static func assemble(dependencies: AppDependencies) -> PracticeView {
        let topicsManager = PracticeTopicsManager(practiceService: dependencies.services.practiceService)
        let viewModel = PracticeViewModel(topicsManager: topicsManager)

        return PracticeView(viewModel: viewModel)
    }

    static func assembleSession(
        topicID: String,
        topicTitle: String,
        dependencies: AppDependencies
    ) -> PracticeSessionView {
        let tasksManager = PracticeTasksManager(
            topicID: topicID,
            practiceService: dependencies.services.practiceService
        )
        let viewModel = PracticeSessionViewModel(
            topicID: topicID,
            topicTitle: topicTitle,
            tasksManager: tasksManager
        )

        return PracticeSessionView(viewModel: viewModel)
    }
}
