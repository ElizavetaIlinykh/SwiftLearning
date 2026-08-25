import SwiftUI

struct LessonQuizRouteView: View {
    // MARK: - Private properties -

    @StateObject private var viewModel: LessonQuizViewModel
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int?

    private var isAnswered: Bool {
        selectedAnswerIndex != nil
    }

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
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadQuestions()
        }
        .refreshable {
            currentQuestionIndex = 0
            selectedAnswerIndex = nil
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
            questionView(contentViewModel.questions)
        }
    }

    // MARK: - Private methods -

    private func questionView(_ questions: [LessonQuizQuestionViewModel]) -> some View {
        let safeQuestionIndex = min(currentQuestionIndex, questions.count - 1)
        let question = questions[safeQuestionIndex]

        return VStack(alignment: .leading, spacing: 24) {
            questionProgress(totalQuestions: questions.count)

            VStack(alignment: .leading, spacing: 10) {
                Text("Quick Check")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(question.text)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 12) {
                ForEach(question.answers.indices, id: \.self) { index in
                    AnswerOptionView(
                        viewModel: AnswerOptionViewModel(
                            title: question.answers[index].text,
                            state: optionState(for: index, in: question.answers)
                        )
                    ) {
                        selectAnswer(index)
                    }
                    .disabled(isAnswered)
                }
            }

            if isAnswered {
                feedbackView(question.answers)

                PrimaryButtonView(title: isLastQuestion(totalQuestions: questions.count) ? "Continue" : "Next Question") {
                    advance(totalQuestions: questions.count)
                }
            }
        }
    }

    private func questionProgress(totalQuestions: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Question \(currentQuestionIndex + 1) of \(totalQuestions)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Spacer()
            }

            ProgressView(value: Double(currentQuestionIndex + 1) / Double(totalQuestions))
                .tint(.accentColor)
        }
    }

    private var loadingView: some View {
        LoadingStateView(title: "Loading questions")
    }

    private func errorView(message: String) -> some View {
        ErrorStateView(
            title: "Could not load questions",
            message: message
        ) {
            Task {
                await viewModel.loadQuestions()
            }
        }
    }

    private var emptyView: some View {
        EmptyStateView(
            title: "No questions yet",
            message: "Continue to the code task."
        ) {
            PrimaryButtonView(title: "Continue") {
                viewModel.openCodeTask()
            }
        }
    }

    private func feedbackView(_ answers: [LessonQuizAnswerViewModel]) -> some View {
        let isCorrect = selectedAnswerIndex.map { answers[$0].isCorrect } ?? false

        return VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(isCorrect ? .green : .red)

                Text(isCorrect ? "Correct!" : "Not quite")
                    .font(.headline)
                    .foregroundStyle(isCorrect ? .green : .red)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func optionState(
        for index: Int,
        in answers: [LessonQuizAnswerViewModel]
    ) -> AnswerOptionState {
        guard let selectedAnswerIndex else { return .neutral }

        if index == selectedAnswerIndex, answers[index].isCorrect {
            return .selectedCorrect
        }

        if index == selectedAnswerIndex {
            return .selectedIncorrect
        }

        if answers[index].isCorrect {
            return .correct
        }

        return .neutral
    }

    private func selectAnswer(_ index: Int) {
        guard selectedAnswerIndex == nil else { return }
        selectedAnswerIndex = index
    }

    private func advance(totalQuestions: Int) {
        if isLastQuestion(totalQuestions: totalQuestions) {
            viewModel.openCodeTask()
        } else {
            currentQuestionIndex += 1
            selectedAnswerIndex = nil
        }
    }

    private func isLastQuestion(totalQuestions: Int) -> Bool {
        currentQuestionIndex == totalQuestions - 1
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
