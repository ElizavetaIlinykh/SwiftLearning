import SwiftUI

@MainActor
enum LearnModuleAssembler {
    static func assemble(dependencies: AppDependencies) -> LearnView {
        let lessonsService = LessonsService(networkManager: dependencies.networkManager)
        let lessonsManager = LessonsManager(lessonsService: lessonsService)
        let viewModel = LearnViewModel(lessonsManager: lessonsManager)

        return LearnView(viewModel: viewModel)
    }
}
