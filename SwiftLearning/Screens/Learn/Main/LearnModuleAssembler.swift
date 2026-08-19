import SwiftUI

@MainActor
enum LearnModuleAssembler {
    // MARK: - Public methods -

    static func assemble(dependencies: AppDependencies) -> LearnView {
        let lessonsManager = LessonsManager(lessonsService: dependencies.services.lessonsService)
        let viewModel = LearnViewModel(lessonsManager: lessonsManager)

        return LearnView(viewModel: viewModel)
    }
}
