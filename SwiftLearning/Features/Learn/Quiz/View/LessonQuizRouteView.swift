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
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(L10n.string("quiz.navigationTitle"))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadQuestions()
        }
        .refreshable {
            await viewModel.loadQuestions()
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
        case let .content(contentViewModel):
            questionView(contentViewModel)
        }
    }

    // MARK: - Private methods -

    private func questionView(_ contentViewModel: LessonQuizContentViewModel) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            questionProgress(contentViewModel)

            questionHeader(contentViewModel.question)

            answersView(contentViewModel)

            if contentViewModel.isAnswered {
                feedbackView(contentViewModel)

                PrimaryButtonView(title: contentViewModel.primaryButtonTitle) {
                    viewModel.advance()
                }
            }
        }
    }

    private func questionHeader(_ question: LessonQuizQuestionViewModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            DifficultyBadgeView(difficulty: question.difficulty)

            Text(L10n.string("quiz.quickCheck"))
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(question.text)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
        }
    }

    private func answersView(_ contentViewModel: LessonQuizContentViewModel) -> some View {
        VStack(spacing: 12) {
            ForEach(contentViewModel.question.answers.indices, id: \.self) { index in
                let answer = contentViewModel.question.answers[index]

                AnswerOptionView(
                    viewModel: AnswerOptionViewModel(
                        title: answer.text,
                        state: answer.state
                    )
                ) {
                    viewModel.selectAnswer(at: index)
                }
                .disabled(contentViewModel.isAnswered)
            }
        }
    }

    private func questionProgress(_ contentViewModel: LessonQuizContentViewModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(contentViewModel.progressTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Spacer()
            }

            ProgressView(value: contentViewModel.progressValue)
                .tint(.accentColor)
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
                await viewModel.loadQuestions()
            }
        }
    }

    private var emptyView: some View {
        EmptyStateView(
            title: L10n.string("quiz.empty.title"),
            message: L10n.string("quiz.empty.message")
        ) {
            PrimaryButtonView(title: L10n.string("common.continue")) {
                viewModel.openCodeTask()
            }
        }
    }

    @ViewBuilder
    private func feedbackView(_ contentViewModel: LessonQuizContentViewModel) -> some View {
        if let answerExplanationViewModel = contentViewModel.answerExplanationViewModel {
            AnswerExplanationView(viewModel: answerExplanationViewModel)
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
