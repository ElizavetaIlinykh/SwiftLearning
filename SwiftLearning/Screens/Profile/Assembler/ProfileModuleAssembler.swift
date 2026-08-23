import SwiftUI

@MainActor
enum ProfileModuleAssembler {
    // MARK: - Public methods -

    static func assemble(dependencies: AppDependencies) -> ProfileView {
        let profileManager = ProfileManager(userService: dependencies.services.userService)
        let viewModel = ProfileViewModel(
            profileManager: profileManager,
            contentBuilder: ProfileContentBuilder(),
            session: dependencies.session
        )

        return ProfileView(viewModel: viewModel)
    }
}
