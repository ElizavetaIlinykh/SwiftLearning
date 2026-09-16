import SwiftUI

struct LessonQuizRouteView: View {
    // MARK: - Private properties -

    @StateObject private var viewModel: LessonQuizViewModel

    // MARK: - Init -

    init(viewModel: LessonQuizViewModel) {
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
        .navigationTitle(L10n.string("quiz.navigationTitle"))
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
            questionView(contentViewData)
        }
    }

    // MARK: - Private methods -

    private func questionView(_ contentViewData: LessonQuizContentViewData) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            questionProgress(contentViewData)

            questionHeader(contentViewData.question)

            answersView(contentViewData)

            if contentViewData.isAnswered {
                feedbackView(contentViewData)

                PrimaryButtonView(title: contentViewData.primaryButtonTitle) {
                    Task {
                        await viewModel.handle(.advance)
                    }
                }
            }
        }
    }

    private func questionHeader(_ question: LessonQuizQuestionViewData) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            DifficultyBadgeView(difficulty: question.difficulty)

            Text(L10n.string("quiz.quickCheck"))
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.textPrimary)

            Text(question.text)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    private func answersView(_ contentViewData: LessonQuizContentViewData) -> some View {
        VStack(spacing: 12) {
            ForEach(contentViewData.question.answers.indices, id: \.self) { index in
                let answer = contentViewData.question.answers[index]

                AnswerOptionView(
                    viewData: AnswerOptionViewData(
                        title: answer.text,
                        state: answer.state
                    )
                ) {
                    Task {
                        await viewModel.handle(.selectAnswer(index))
                    }
                }
                .disabled(contentViewData.isAnswered)
            }
        }
    }

    private func questionProgress(_ contentViewData: LessonQuizContentViewData) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(contentViewData.progressTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textSecondary)

                Spacer()
            }

            AppProgressBarView(value: contentViewData.progressValue)
        }
    }

    private var loadingView: some View {
        LoadingStateView(title: L10n.string("quiz.loadingQuestions"))
    }

    private func errorView(message: String) -> some View {
        ErrorStateView(
            title: L10n.string("quiz.error.loadQuestions"),
            message: message
        ) {
            Task {
                await viewModel.handle(.retry)
            }
        }
    }

    private var emptyView: some View {
        EmptyStateView(
            title: L10n.string("quiz.empty.title"),
            message: L10n.string("quiz.empty.message")
        ) {
            PrimaryButtonView(title: L10n.string("common.continue")) {
                Task {
                    await viewModel.handle(.openCodeTask)
                }
            }
        }
    }

    @ViewBuilder
    private func feedbackView(_ contentViewData: LessonQuizContentViewData) -> some View {
        if let answerExplanationViewData = contentViewData.answerExplanationViewData {
            AnswerExplanationView(viewData: answerExplanationViewData)
        }
    }
}

#Preview {
    NavigationStack {
        LessonQuizModuleAssembler.assemble(
            lessonID: "57451d1d-27d4-40a3-86a1-3c06b176be68",
            dependencies: AppDependenciesAssembler.assemble(),
            output: { _ in }
        )
    }
}
