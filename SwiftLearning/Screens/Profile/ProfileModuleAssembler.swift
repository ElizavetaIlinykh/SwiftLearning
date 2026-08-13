import SwiftUI

@MainActor
enum ProfileModuleAssembler {
    static func assemble(dependencies: AppDependencies) -> ProfileView {
        let profileManager = ProfileManager(userService: dependencies.services.userService)
        let viewModel = ProfileViewModel(
            profileManager: profileManager,
            session: dependencies.session
        )

        return ProfileView(viewModel: viewModel)
    }
}
