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

    @State private var selectedTab: MainTab = .learn

    // MARK: - Public properties -

    var body: some View {
        TabView(selection: $selectedTab) {
            LearnCoordinatorView(dependencies: dependencies)
                .tabItem {
                    Label("Learn", systemImage: "book.fill")
                }
                .tag(MainTab.learn)

            PracticeCoordinatorView(dependencies: dependencies)
                .tabItem {
                    Label("Practice", systemImage: "chevron.left.forwardslash.chevron.right")
                }
                .tag(MainTab.practice)

            ProfileCoordinatorView(dependencies: dependencies)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(MainTab.profile)
        }
    }
}

#Preview {
    MainTabView(dependencies: AppDependenciesAssembler.assemble())
}
