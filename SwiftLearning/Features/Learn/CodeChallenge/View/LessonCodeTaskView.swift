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
            .padding(AppSpacing.screen)
        }
        .background(AppColors.background)
        .navigationTitle(L10n.string("codeTask.navigationTitle"))
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
        case let .content(contentViewData):
            codeTaskContent(contentViewData)
        case .notAvailable:
            noCodeTaskView
        case let .error(message):
            errorView(message: message)
        }
    }

    // MARK: - Private methods -

    private func codeTaskContent(_ contentViewData: LessonCodeTaskContentViewData) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            codeTaskHeader(contentViewData)

            codeBlockSection(contentViewData)

            answerSection

            feedbackView

            primaryButton
        }
    }

    private func codeTaskHeader(_ contentViewData: LessonCodeTaskContentViewData) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(L10n.string("codeTask.title"))
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.textPrimary)

            Text(contentViewData.title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textPrimary)

            Text(contentViewData.description)
                .font(.body)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    private func codeBlockSection(_ contentViewData: LessonCodeTaskContentViewData) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(contentViewData.codeSectionTitle)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.textSecondary)

            CodeBlockView(
                viewData: CodeBlockViewData(code: contentViewData.code)
            )
        }
    }

    private var primaryButton: some View {
        let buttonViewData = viewModel.primaryButtonViewData

        return PrimaryButtonView(title: buttonViewData.title) {
            Task {
                await viewModel.performPrimaryAction(buttonViewData.action)
            }
        }
        .disabled(buttonViewData.isDisabled)
    }

    private var answerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(L10n.string("codeTask.answerSection"))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.textSecondary)

            TextField(L10n.string("codeTask.answerPlaceholder"), text: $viewModel.answer)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(.body.monospaced())
                .appInputField(
                    borderColor: answerBorderColor,
                    lineWidth: 1.5
                )
                .disabled(viewModel.answerState == .correct)
        }
    }

    private var noCodeTaskView: some View {
        EmptyStateView(
            title: L10n.string("codeTask.noTask.title"),
            message: L10n.string("codeTask.noTask.message")
        ) {
            primaryButton
        }
    }

    private var loadingView: some View {
        LoadingStateView(title: L10n.string("codeTask.loading"))
    }

    private func errorView(message: String) -> some View {
        ErrorStateView(
            title: L10n.string("codeTask.error.load"),
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
                title: L10n.string("codeTask.completed.title"),
                message: L10n.string("codeTask.completed.message"),
                systemImage: "checkmark.circle.fill",
                color: AppColors.success
            )
        case .incorrect:
            Text(L10n.string("codeTask.tryAgain"))
                .font(.headline)
                .foregroundStyle(AppColors.error)
                .frame(maxWidth: .infinity, alignment: .leading)
        }

        if case let .failed(message) = viewModel.completionState {
            Text(message)
                .font(.subheadline)
                .foregroundStyle(AppColors.error)
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
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard(
            radius: AppRadius.largeCard,
            padding: AppSpacing.section
        )
    }

    private var answerBorderColor: Color {
        switch viewModel.answerState {
        case .idle:
            AppColors.border
        case .correct:
            AppColors.success.opacity(AppOpacity.activeBorder)
        case .incorrect:
            AppColors.error.opacity(AppOpacity.activeBorder)
        }
    }
}

#Preview {
    NavigationStack {
        LessonCodeTaskAssembler.assemble(
            lessonID: "57451d1d-27d4-40a3-86a1-3c06b176be68",
            dependencies: AppDependenciesAssembler.assemble(),
            output: { _ in }
        )
    }
}
