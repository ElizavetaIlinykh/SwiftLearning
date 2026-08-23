import SwiftUI

struct LessonCodeTaskView: View {
    // MARK: - Private properties -

    @StateObject private var viewModel: LessonCodeTaskViewModel

    // MARK: - Init -

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
        switch viewModel.state {
        case .loading:
            loadingView
        case let .content(contentViewModel):
            codeTaskContent(contentViewModel)
        case .notAvailable:
            noCodeTaskView
        case let .error(message):
            errorView(message: message)
        }
    }

    // MARK: - Private methods -

    private func codeTaskContent(_ contentViewModel: LessonCodeTaskContentViewModel) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            codeTaskHeader(contentViewModel)

            codeBlockSection(contentViewModel)

            answerSection

            feedbackView

            primaryButton
        }
    }

    private func codeTaskHeader(_ contentViewModel: LessonCodeTaskContentViewModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Code Task")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(contentViewModel.title)
                .font(.title3)
                .fontWeight(.semibold)

            Text(contentViewModel.description)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    private func codeBlockSection(_ contentViewModel: LessonCodeTaskContentViewModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(contentViewModel.codeSectionTitle)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            CodeBlockView(code: contentViewModel.code)
        }
    }

    private var primaryButton: some View {
        let buttonViewModel = viewModel.primaryButtonViewModel

        return PrimaryButton(title: buttonViewModel.title) {
            Task {
                await viewModel.performPrimaryAction(buttonViewModel.action)
            }
        }
        .disabled(buttonViewModel.isDisabled)
    }

    private var answerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ANSWER")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            TextField("Enter missing code", text: $viewModel.answer)
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
                .disabled(viewModel.answerState == .correct)
        }
    }

    private var noCodeTaskView: some View {
        EmptyStateView(
            title: "No code task",
            message: "Continue to complete this lesson."
        ) {
            primaryButton
        }
    }

    private var loadingView: some View {
        LoadingStateView(title: "Loading code task")
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
        switch viewModel.answerState {
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
        switch viewModel.answerState {
        case .idle:
            Color.primary.opacity(0.08)
        case .correct:
            Color.green.opacity(0.55)
        case .incorrect:
            Color.red.opacity(0.55)
        }
    }
}

#Preview {
    NavigationStack {
        LessonCodeTaskAssembler.assemble(
            lessonID: "57451d1d-27d4-40a3-86a1-3c06b176be68",
            dependencies: AppDependenciesAssembler.assemble(),
            onOpenResult: { _ in }
        )
    }
}
