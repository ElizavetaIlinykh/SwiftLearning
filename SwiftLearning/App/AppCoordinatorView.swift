import SwiftUI

struct AppCoordinatorView: View {
    // MARK: - Public properties -

    let dependencies: AppDependencies

    // MARK: - Private properties -

    @Environment(ThemeSettings.self) private var themeSettings
    @ObservedObject private var session: SessionState

    // MARK: - Init -

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        session = dependencies.session
    }

    // MARK: - Public properties -

    var body: some View {
        Group {
            switch session.status {
            case .unknown:
                ProgressView(L10n.string("app.checkingSession"))
                    .foregroundStyle(AppColors.textSecondary)
                    .tint(AppColors.primary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.background)
            case .authenticated:
                MainCoordinatorView(dependencies: dependencies)
            case .unauthenticated:
                AuthCoordinatorView(dependencies: dependencies)
            }
        }
        .preferredColorScheme(themeSettings.selectedTheme.colorScheme)
        .task {
            await session.restoreSession()
        }
    }
}

#Preview {
    let dependencies = AppDependenciesAssembler.assemble()

    AppCoordinatorView(dependencies: dependencies)
        .environment(dependencies.languageSettings)
        .environment(dependencies.themeSettings)
}
