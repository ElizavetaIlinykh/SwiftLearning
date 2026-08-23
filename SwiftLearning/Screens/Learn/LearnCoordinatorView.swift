import SwiftUI

struct LearnCoordinatorView: View {
    // MARK: - Public properties -

    let dependencies: AppDependencies

    // MARK: - Private properties -

    @State private var router = LearnRouter()

    // MARK: - Public properties -

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            LearnModuleAssembler.assemble(
                dependencies: dependencies,
                onOpenLesson: { id, totalLessonsCount in
                    router.navigate(to: .lesson(id: id, totalLessonsCount: totalLessonsCount))
                }
            )
            .navigationDestination(for: LearnRouter.Route.self) { route in
                destination(for: route)
            }
        }
        .environment(router)
    }

    // MARK: - Private methods -

    @ViewBuilder
    private func destination(for route: LearnRouter.Route) -> some View {
        switch route {
        case let .lesson(id, totalLessonsCount):
            LessonModuleAssembler.assemble(
                lessonID: id,
                totalLessonsCount: totalLessonsCount,
                dependencies: dependencies,
                onContinueToQuiz: { lessonID in
                    router.navigate(to: .quiz(lessonID: lessonID))
                }
            )
        case let .quiz(lessonID):
            LessonQuizModuleAssembler.assemble(
                lessonID: lessonID,
                dependencies: dependencies,
                onOpenCodeTask: { lessonID in
                    router.navigate(to: .codeTask(lessonID: lessonID))
                }
            )
        case let .codeTask(lessonID):
            LessonCodeTaskAssembler.assemble(
                lessonID: lessonID,
                dependencies: dependencies,
                onOpenResult: { lessonID in
                    router.navigate(to: .result(lessonID: lessonID))
                }
            )
        case let .result(lessonID):
            LessonCompletionResultView(
                viewModel: LessonCompletionResultViewModel(
                    lessonID: lessonID,
                    onContinueLearning: {
                        router.popToRoot()
                    }
                )
            )
        }
    }
}

#Preview {
    LearnCoordinatorView(dependencies: AppDependenciesAssembler.assemble())
}
