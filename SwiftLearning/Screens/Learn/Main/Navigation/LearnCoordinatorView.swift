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
                output: { output in
                    switch output {
                    case let .openLesson(id, lessonsCount):
                        router.navigate(to: .lesson(id: id, totalLessonsCount: lessonsCount))
                    }
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
                output: { output in
                    switch output {
                    case let .openQuiz(lessonID):
                        router.navigate(to: .quiz(lessonID: lessonID))
                    }
                }
            )
        case let .quiz(lessonID):
            LessonQuizModuleAssembler.assemble(
                lessonID: lessonID,
                dependencies: dependencies,
                output: { output in
                    switch output {
                    case let .openCodeTask(lessonID):
                        router.navigate(to: .codeTask(lessonID: lessonID))
                    }
                }
            )
        case let .codeTask(lessonID):
            LessonCodeTaskAssembler.assemble(
                lessonID: lessonID,
                dependencies: dependencies,
                output: { output in
                    switch output {
                    case let .openResult(lessonID):
                        router.navigate(to: .result(lessonID: lessonID))
                    }
                }
            )
        case let .result(lessonID):
            LessonCompletionResultView(
                viewModel: LessonCompletionResultViewModel(
                    lessonID: lessonID,
                    output: { output in
                        switch output {
                        case .continueLearning:
                            router.popToRoot()
                        }
                    }
                )
            )
        }
    }
}

#Preview {
    LearnCoordinatorView(dependencies: AppDependenciesAssembler.assemble())
}
