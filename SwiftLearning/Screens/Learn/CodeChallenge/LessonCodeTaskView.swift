import SwiftUI

struct LessonCodeTaskView: View {
    // MARK: - Private properties -

    @Environment(AppRouter.self) private var router
    @StateObject private var viewModel: LessonCodeTaskViewModel

    // MARK: - Init -

    @State private var answer = ""
    @State private var answerState: AnswerState = .idle
    init(viewModel: LessonCodeTaskViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Public properties -

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                content
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Code Task")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadCodeTask()
        }
        .refreshable {
            await viewModel.loadCodeTask()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.codeTaskState {
        case .idle, .loading:
            loadingView
        case let .loaded(codeTask):
            codeTaskContent(codeTask)
        case .notAvailable:
            noCodeTaskView
        case let .failed(message):
            errorView(message: message)
        }
    }

    // MARK: - Private methods -

    private func codeTaskContent(_ codeTask: LessonCodeTask) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            codeTaskHeader(codeTask)

            codeBlockSection(codeTask)

            answerSection

            feedbackView

            if answerState == .correct {
                PrimaryButton(title: completionButtonTitle) {
                    Task {
                        await completeLesson()
                    }
                }
                .disabled(isCompleting)
            } else {
                PrimaryButton(title: "Check Answer") {
                    checkAnswer(for: codeTask)
                }
            }
        }
    }

    private func codeTaskHeader(_ codeTask: LessonCodeTask) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Code Task")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(codeTask.title)
                .font(.title3)
                .fontWeight(.semibold)

            Text(codeTask.description)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    private func codeBlockSection(_ codeTask: LessonCodeTask) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(answerState == .correct ? "COMPLETED CODE" : "COMPLETE THE CODE")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            CodeBlockView(code: codeTask.code)
        }
    }

    private var answerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ANSWER")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            TextField("Enter missing code", text: $answer)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(.body.monospaced())
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(answerBorderColor, lineWidth: 1.5)
                )
                .disabled(answerState == .correct)
        }
    }

    private var noCodeTaskView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("No code task")
                .font(.headline)

            Text("Continue to complete this lesson.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            PrimaryButton(title: completionButtonTitle) {
                Task {
                    await completeLesson()
                }
            }
            .disabled(isCompleting)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }

    private var loadingView: some View {
        VStack(spacing: 14) {
            ProgressView()
            Text("Loading code task")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }

    private func errorView(message: String) -> some View {
        ErrorStateView(
            title: "Could not load code task",
            message: message
        ) {
            Task {
                await viewModel.loadCodeTask()
            }
        }
    }

    @ViewBuilder
    private var feedbackView: some View {
        switch answerState {
        case .idle:
            EmptyView()
        case .correct:
            statusView(
                title: "Great job!",
                message: "You completed the task.",
                systemImage: "checkmark.circle.fill",
                color: .green
            )
        case .incorrect:
            Text("Try again")
                .font(.headline)
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
        }

        if case let .failed(message) = viewModel.completionState {
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.red)
        }
    }

    private func statusView(
        title: String,
        message: String,
        systemImage: String,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .foregroundStyle(color)

                Text(title)
                    .font(.headline)
                    .foregroundStyle(color)
            }

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var answerBorderColor: Color {
        switch answerState {
        case .idle:
            Color.primary.opacity(0.08)
        case .correct:
            Color.green.opacity(0.55)
        case .incorrect:
            Color.red.opacity(0.55)
        }
    }

    private var completionButtonTitle: String {
        isCompleting ? "Completing..." : "Finish Lesson"
    }

    private var isCompleting: Bool {
        if case .completing = viewModel.completionState {
            return true
        }
        return false
    }

    private func checkAnswer(for codeTask: LessonCodeTask) {
        answerState = viewModel.isCorrectAnswer(answer, for: codeTask) ? .correct : .incorrect
    }

    private func completeLesson() async {
        let didComplete = await viewModel.completeLesson()

        if didComplete {
            router.push(.result(lessonID: viewModel.lessonID))
        }
    }
}

private enum AnswerState {
    case idle
    case correct
    case incorrect
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
