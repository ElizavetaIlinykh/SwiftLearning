import SwiftUI

struct ProfileSettingsView: View {
    // MARK: - Public properties -

    var body: some View {
        Form {
            Section {
                NavigationLink(value: ProfileRouter.Route.languageSettings) {
                    settingsRow(
                        title: L10n.string("profile.language.section"),
                        systemImage: "globe"
                    )
                }

                NavigationLink(value: ProfileRouter.Route.themeSettings) {
                    settingsRow(
                        title: L10n.string("profile.theme.section"),
                        systemImage: "circle.lefthalf.filled"
                    )
                }
            }
            .listRowBackground(AppColors.card)
        }
        .appSettingsForm()
        .navigationTitle(L10n.string("profile.settings"))
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Private methods -

    private func settingsRow(title: String, systemImage: String) -> some View {
        Label {
            Text(title)
                .foregroundStyle(AppColors.textPrimary)
        } icon: {
            Image(systemName: systemImage)
                .foregroundStyle(AppColors.primary)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileSettingsView()
            .navigationDestination(for: ProfileRouter.Route.self) { _ in
                EmptyView()
            }
    }
    .environment(LanguageSettings())
    .environment(ThemeSettings())
}
