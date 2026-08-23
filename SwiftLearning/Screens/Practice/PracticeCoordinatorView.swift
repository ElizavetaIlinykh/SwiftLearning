import SwiftUI

struct PracticeCoordinatorView: View {
    // MARK: - Public properties -

    let dependencies: AppDependencies

    // MARK: - Private properties -

    @State private var router = PracticeRouter()

    // MARK: - Public properties -

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            PracticeModuleAssembler.assemble(
                dependencies: dependencies,
                output: { output in
                    switch output {
                    case let .openTopic(id, title):
                        router.navigate(
                            to: .exercise(
                                id: id,
                                title: title,
                                attemptID: UUID()
                            )
                        )
                    }
                }
            )
            .navigationDestination(for: PracticeRouter.Route.self) { route in
                destination(for: route)
            }
        }
        .environment(router)
    }

    // MARK: - Private methods -

    @ViewBuilder
    private func destination(for route: PracticeRouter.Route) -> some View {
        switch route {
        case let .exercise(id, title, _):
            PracticeModuleAssembler.assembleSession(
                topicID: id,
                topicTitle: title,
                dependencies: dependencies,
                output: { output in
                    switch output {
                    case .closePractice:
                        router.popToRoot()
                    case let .openResult(progress):
                        router.navigate(
                            to: .result(
                                topicID: id,
                                topicTitle: title,
                                progress: progress
                            )
                        )
                    }
                }
            )
        case let .result(topicID, topicTitle, progress):
            PracticeResultView(
                topicTitle: topicTitle,
                progress: progress,
                onPracticeAgain: {
                    router.restartPractice(topicID: topicID, topicTitle: topicTitle)
                },
                onDone: {
                    router.popToRoot()
                }
            )
        }
    }
}

#Preview {
    PracticeCoordinatorView(dependencies: AppDependenciesAssembler.assemble())
}
