import SwiftUI

@MainActor
enum LearnModuleAssembler {
    static func assemble(dependencies: AppDependencies) -> LearnView {
        let lessonsManager = LessonsManager(lessonsService: dependencies.services.lessonsService)
        let viewModel = LearnViewModel(lessonsManager: lessonsManager)

        return LearnView(viewModel: viewModel)
    }
}
