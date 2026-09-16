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

    static func assembleLesson(
        topicID: String,
        topicTitle: String,
        dependencies: AppDependencies,
        output: @escaping (PracticeLessonOutput) -> Void
    ) -> PracticeLessonView {
        let tasksManager = PracticeTasksManager(
            topicID: topicID,
            practiceService: dependencies.services.practiceService
        )
        let viewModel = PracticeLessonViewModel(
            topicTitle: topicTitle,
            tasksManager: tasksManager,
            taskBuilder: PracticeTaskBuilder(),
            contentBuilder: PracticeLessonContentBuilder(),
            output: output
        )

        return PracticeLessonView(viewModel: viewModel)
    }
}
