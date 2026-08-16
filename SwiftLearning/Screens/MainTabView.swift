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
            PracticeModuleAssembler.assemble(dependencies: dependencies)
                .navigationDestination(for: PracticeRoute.self) { route in
                    practiceDestination(for: route)
                }
        }
    }

    private var profileStack: some View {
        @Bindable var router = router

        return NavigationStack(path: $router.profilePath) {
            ProfileModuleAssembler.assemble(dependencies: dependencies)
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
        case .quiz(let lessonID):
            LessonQuizModuleAssembler.assemble(
                lessonID: lessonID,
                dependencies: dependencies
            )
        case .codeTask(let lessonID):
            LessonCodeTaskAssembler.assemble(
                lessonID: lessonID,
                dependencies: dependencies
            )
        case .result(let lessonID):
            LessonCompletionResultView(lessonID: lessonID)
        }
    }

    @ViewBuilder
    private func practiceDestination(for route: PracticeRoute) -> some View {
        switch route {
        case .topic(let id, let title), .exercise(let id, let title, _):
            PracticeModuleAssembler.assembleSession(
                topicID: id,
                topicTitle: title,
                dependencies: dependencies
            )
        case .result(let topicID, let topicTitle, let progress):
            PracticeResultView(
                topicTitle: topicTitle,
                progress: progress,
                onPracticeAgain: {
                    router.restartPractice(topicID: topicID, topicTitle: topicTitle)
                },
                onDone: {
                    router.popPracticeToRoot()
                }
            )
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
}
