import SwiftUI

struct MainTabView: View {
    @Environment(AppRouter.self) private var router

    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    var body: some View {
        @Bindable var router = router

        TabView(selection: $router.selectedTab) {
            lessonsStack
                .tabItem {
                    Label("Learn", systemImage: "book.fill")
                }
                .tag(AppTab.lessons)

            practiceStack
                .tabItem {
                    Label("Practice", systemImage: "chevron.left.forwardslash.chevron.right")
                }
                .tag(AppTab.practice)

            profileStack
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(AppTab.profile)
        }
    }

    private var lessonsStack: some View {
        @Bindable var router = router

        return NavigationStack(path: $router.lessonsPath) {
            LearnModuleAssembler.assemble(dependencies: dependencies)
                .navigationDestination(for: LessonsRoute.self) { route in
                    lessonsDestination(for: route)
                }
        }
    }

    private var practiceStack: some View {
        @Bindable var router = router

        return NavigationStack(path: $router.practicePath) {
            PracticeView()
                .navigationDestination(for: PracticeRoute.self) { route in
                    practiceDestination(for: route)
                }
        }
    }

    private var profileStack: some View {
        @Bindable var router = router

        return NavigationStack(path: $router.profilePath) {
            ProfileView()
                .navigationDestination(for: ProfileRoute.self) { route in
                    profileDestination(for: route)
                }
        }
    }

    @ViewBuilder
    private func lessonsDestination(for route: LessonsRoute) -> some View {
        switch route {
        case .lesson(let id, let totalLessonsCount):
            LessonModuleAssembler.assemble(
                lessonID: id,
                totalLessonsCount: totalLessonsCount,
                dependencies: dependencies
            )
        case .quiz:
            RoutePlaceholderView(title: "Quiz")
        case .result(let score):
            RoutePlaceholderView(title: "Result: \(score)")
        }
    }

    @ViewBuilder
    private func practiceDestination(for route: PracticeRoute) -> some View {
        switch route {
        case .topic(let id), .exercise(let id, _):
            if let category = PracticeData.category(id: id) {
                PracticeSessionView(category: category)
            } else {
                RoutePlaceholderView(title: "Practice")
            }
        case .result(let categoryID, let correctAnswersCount, let totalQuestions):
            if let category = PracticeData.category(id: categoryID) {
                PracticeResultView(
                    category: category,
                    correctAnswersCount: correctAnswersCount,
                    totalQuestions: totalQuestions,
                    onPracticeAgain: {
                        router.restartPractice(categoryID: categoryID)
                    },
                    onDone: {
                        router.popPracticeToRoot()
                    }
                )
            } else {
                RoutePlaceholderView(title: "Practice Result")
            }
        }
    }

    @ViewBuilder
    private func profileDestination(for route: ProfileRoute) -> some View {
        switch route {
        case .statistics:
            RoutePlaceholderView(title: "Statistics")
        case .settings:
            RoutePlaceholderView(title: "Settings")
        }
    }
}

#Preview {
    MainTabView(dependencies: AppDependenciesAssembler.assemble())
        .environment(AppRouter())
        .environmentObject(LearningProgressStore())
}
