import SwiftUI

@MainActor
enum PracticeModuleAssembler {
    // MARK: - Public methods -

    static func assemble(
        dependencies: AppDependencies,
        output: @escaping (PracticeOutput) -> Void
    ) -> PracticeView {
        let topicsManager = PracticeTopicsManager(practiceService: dependencies.services.practiceService)
        let viewModel = PracticeViewModel(
            topicsManager: topicsManager,
            categoryCardBuilder: PracticeCategoryCardBuilder(),
            output: output
        )

        return PracticeView(viewModel: viewModel)
    }

    static func assembleSession(
        topicID: String,
        topicTitle: String,
        dependencies: AppDependencies,
        output: @escaping (PracticeSessionOutput) -> Void
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
            output: output
        )

        return PracticeSessionView(viewModel: viewModel)
    }
}
