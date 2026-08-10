import SwiftUI

struct MainTabView: View {
    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    var body: some View {
        TabView {
            LearnModuleAssembler.assemble(dependencies: dependencies)
                .tabItem {
                    Label("Learn", systemImage: "book.fill")
                }

            PracticeView()
                .tabItem {
                    Label("Practice", systemImage: "chevron.left.forwardslash.chevron.right")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    MainTabView(dependencies: AppDependenciesAssembler.assemble())
        .environmentObject(LearningProgressStore())
}
