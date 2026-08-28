import SwiftUI

enum MainTab: Hashable {
    case learn
    case practice
    case profile
}

struct MainTabView: View {
    // MARK: - Public properties -

    let dependencies: AppDependencies

    // MARK: - Private properties -

    @Environment(LanguageSettings.self) private var languageSettings
    @State private var selectedTab: MainTab = .learn

    // MARK: - Public properties -

    var body: some View {
        let languageID = languageSettings.selectedLanguage.id

        TabView(selection: $selectedTab) {
            LearnCoordinatorView(dependencies: dependencies)
                .id(languageID)
                .tabItem {
                    Label(L10n.string("tabs.learn"), systemImage: "book.fill")
                }
                .tag(MainTab.learn)

            PracticeCoordinatorView(dependencies: dependencies)
                .id(languageID)
                .tabItem {
                    Label(L10n.string("tabs.practice"), systemImage: "chevron.left.forwardslash.chevron.right")
                }
                .tag(MainTab.practice)

            ProfileCoordinatorView(dependencies: dependencies)
                .id(languageID)
                .tabItem {
                    Label(L10n.string("tabs.profile"), systemImage: "person.fill")
                }
                .tag(MainTab.profile)
        }
    }
}

#Preview {
    MainTabView(dependencies: AppDependenciesAssembler.assemble())
        .environment(LanguageSettings())
}
