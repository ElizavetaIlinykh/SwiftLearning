import SwiftUI

@MainActor
enum AuthModuleAssembler {
    // MARK: - Public methods -

    static func assembleLogin(
        dependencies: AppDependencies,
        output: @escaping (AuthOutput) -> Void
    ) -> LoginView {
        let viewModel = LoginViewModel(
            session: dependencies.session,
            output: output
        )

        return LoginView(viewModel: viewModel)
    }

    static func assembleRegister(
        dependencies: AppDependencies,
        output: @escaping (AuthOutput) -> Void
    ) -> RegisterView {
        let viewModel = RegisterViewModel(
            session: dependencies.session,
            output: output
        )

        return RegisterView(viewModel: viewModel)
    }
}
