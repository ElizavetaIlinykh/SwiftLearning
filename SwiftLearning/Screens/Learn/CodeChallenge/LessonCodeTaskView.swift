import SwiftUI

struct LessonCodeTaskView: View {
    @Environment(AppRouter.self) private var router
    @StateObject private var viewModel: LessonCompletionViewModel

    private let lessonID: String

    init(
        lessonID: String,
        viewModel: LessonCompletionViewModel
    ) {
        self.lessonID = lessonID
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Code Task")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Complete the code task to finish the lesson.")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("TASK")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)

                    CodeBlockView(code: "// Code task content will be loaded from backend here")
                }

                if case .failed(let message) = viewModel.state {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                }

                PrimaryButton(title: buttonTitle) {
                    Task {
                        let didComplete = await viewModel.completeLesson()

                        if didComplete {
                            router.push(.result(lessonID: lessonID))
                        }
                    }
                }
                .disabled(isCompleting)
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Code Task")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var buttonTitle: String {
        isCompleting ? "Completing..." : "Finish Lesson"
    }

    private var isCompleting: Bool {
        if case .completing = viewModel.state { return true }
        return false
    }
}

#Preview {
    NavigationStack {
        LessonCodeTaskAssembler.assemble(
            lessonID: "57451d1d-27d4-40a3-86a1-3c06b176be68",
            dependencies: AppDependenciesAssembler.assemble()
        )
        .environment(AppRouter())
    }
}
