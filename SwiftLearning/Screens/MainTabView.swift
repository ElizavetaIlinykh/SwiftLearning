import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            LearnView()
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
    MainTabView()
        .environmentObject(LearningProgressStore())
}
