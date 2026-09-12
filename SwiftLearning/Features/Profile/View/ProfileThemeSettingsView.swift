import SwiftUI

struct ProfileThemeSettingsView: View {
    // MARK: - Private properties -

    @Environment(ThemeSettings.self) private var themeSettings

    // MARK: - Public properties -

    var body: some View {
        @Bindable var themeSettings = themeSettings

        Form {
            Section {
                Picker(
                    L10n.string("profile.theme.section"),
                    selection: $themeSettings.selectedTheme
                ) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(L10n.string(theme.localizedTitleKey))
                            .foregroundStyle(AppColors.textPrimary)
                            .tag(theme)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }
            .listRowBackground(AppColors.card)
        }
        .appSettingsForm()
        .navigationTitle(L10n.string("profile.theme.section"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProfileThemeSettingsView()
    }
    .environment(ThemeSettings())
}
