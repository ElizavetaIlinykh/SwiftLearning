import SwiftUI

struct PracticeLessonView: View {
    // MARK: - Private properties -

    @StateObject private var viewModel: PracticeLessonViewModel

    // MARK: - Init -

    init(viewModel: PracticeLessonViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Public properties -

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                content
            }
            .padding(AppSpacing.screen)
        }
        .background(AppColors.background)
        .navigationTitle(viewModel.topicTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.handle(.load)
        }
        .refreshable {
            await viewModel.handle(.refresh)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case let .error(message):
            errorView(message: message)
        case .empty:
            emptyView
        case let .content(contentViewData):
            taskContent(contentViewData)
        }
    }

    // MARK: - Private methods -

    private func taskContent(_ contentViewData: PracticeLessonContentViewData) -> some View {
        VStack(alignment: .leading, spacing: 22) {
            taskProgress(contentViewData)

            taskHeader(contentViewData.task)

            answersView(contentViewData)

            if contentViewData.isAnswered {
                feedbackView(contentViewData)
                paginationErrorView(contentViewData)

                PrimaryButtonView(
                    title: contentViewData.actionButtonTitle,
                    action: {
                        Task {
                            await viewModel.handle(.advance)
                        }
                    }
                )
                .disabled(contentViewData.isActionButtonDisabled)
            }
        }
    }

    private func taskHeader(_ task: PracticeTaskViewData) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            DifficultyBadgeView(difficulty: task.difficulty)

            Text(task.question)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.leading)

            if let code = task.code {
                CodeBlockView(
                    viewData: CodeBlockViewData(code: code)
                )
            }
        }
    }

    private func answersView(_ contentViewData: PracticeLessonContentViewData) -> some View {
        VStack(spacing: 12) {
            ForEach(contentViewData.task.answers) { answer in
                AnswerOptionView(
                    viewData: AnswerOptionViewData(
                        title: answer.text,
                        state: answer.state
                    )
                ) {
                    Task {
                        await viewModel.handle(.selectAnswer(answer.id))
                    }
                }
                .disabled(contentViewData.isAnswered)
            }
        }
    }

    private func taskProgress(_ contentViewData: PracticeLessonContentViewData) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(contentViewData.progressTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textSecondary)

                Spacer()

                Text(contentViewData.topicTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.primary)
            }

            AppProgressBarView(value: contentViewData.progressValue)
        }
    }

    private var loadingView: some View {
        LoadingStateView(title: L10n.string("practice.loadingTasks"))
    }

    private func errorView(message: String) -> some View {
        ErrorStateView(
            title: L10n.string("practice.error.loadTasks"),
            message: message
        ) {
            Task {
                await viewModel.handle(.retry)
            }
        }
    }

    private var emptyView: some View {
        EmptyStateView(
            title: L10n.string("practice.emptyTasks.title"),
            message: L10n.string("practice.emptyTasks.message")
        ) {
            Button(L10n.string("common.done")) {
                Task {
                    await viewModel.handle(.close)
                }
            }
            .appSecondaryButton()
        }
    }

    @ViewBuilder
    private func feedbackView(_ contentViewData: PracticeLessonContentViewData) -> some View {
        if let answerExplanationViewData = contentViewData.answerExplanationViewData {
            AnswerExplanationView(viewData: answerExplanationViewData)
        }
    }

    @ViewBuilder
    private func paginationErrorView(_ contentViewData: PracticeLessonContentViewData) -> some View {
        if let message = contentViewData.paginationErrorMessage {
            Text(message)
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    NavigationStack {
        PracticeModuleAssembler.assembleLesson(
            topicID: "topic-uuid",
            topicTitle: "Variables and Constants",
            dependencies: AppDependenciesAssembler.assemble(),
            output: { _ in }
        )
    }
}
