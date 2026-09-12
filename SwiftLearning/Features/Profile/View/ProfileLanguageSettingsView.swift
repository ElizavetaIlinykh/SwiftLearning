import SwiftUI

struct ProfileLanguageSettingsView: View {
    // MARK: - Private properties -

    @Environment(LanguageSettings.self) private var languageSettings

    // MARK: - Public properties -

    var body: some View {
        @Bindable var languageSettings = languageSettings

        Form {
            Section {
                Picker(
                    L10n.string("profile.language.section"),
                    selection: $languageSettings.selectedLanguage
                ) {
                    ForEach(AppLanguage.allCases) { language in
                        Text(L10n.string(language.localizedTitleKey))
                            .foregroundStyle(AppColors.textPrimary)
                            .tag(language)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }
            .listRowBackground(AppColors.card)
        }
        .appSettingsForm()
        .navigationTitle(L10n.string("profile.language.section"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProfileLanguageSettingsView()
    }
    .environment(LanguageSettings())
}
