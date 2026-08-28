import SwiftUI

struct ProfileSettingsView: View {
    // MARK: - Private properties -

    @Environment(LanguageSettings.self) private var languageSettings

    // MARK: - Public properties -

    var body: some View {
        @Bindable var languageSettings = languageSettings

        Form {
            Section(L10n.string("profile.language.section")) {
                Picker(
                    L10n.string("profile.language.section"),
                    selection: $languageSettings.selectedLanguage
                ) {
                    ForEach(AppLanguage.allCases) { language in
                        Text(L10n.string(language.localizedTitleKey))
                            .tag(language)
                    }
                }
                .pickerStyle(.inline)
            }
        }
        .navigationTitle(L10n.string("profile.settings"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProfileSettingsView()
    }
    .environment(LanguageSettings())
}
