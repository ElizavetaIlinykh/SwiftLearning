import SwiftUI

struct LessonQuizRouteView: View {
    // MARK: - Private properties -

    @Environment(AppRouter.self) private var router
    @StateObject private var viewModel: LessonQuizViewModel

    // MARK: - Init -

    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int?
    init(viewModel: LessonQuizViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    private var isAnswered: Bool {
        selectedAnswerIndex != nil
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
            await viewModel.loadQuestions()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingView
        case let .failed(message):
            errorView(message: message)
        case let .loaded(questions):
            let sortedQuestions = questions.sorted { $0.order < $1.order }

            if sortedQuestions.isEmpty {
                emptyView
            } else {
                questionView(sortedQuestions)
            }
        }
    }

    // MARK: - Private methods -

    private func questionView(_ questions: [LessonQuizQuestion]) -> some View {
        let question = questions[currentQuestionIndex]
        let answers = question.answers.sorted { $0.order < $1.order }

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
                ForEach(answers.indices, id: \.self) { index in
                    AnswerOptionView(
                        title: answers[index].text,
                        state: optionState(for: index, in: answers)
                    ) {
                        selectAnswer(index)
                    }
                    .disabled(isAnswered)
                }
            }

            if isAnswered {
                feedbackView(answers)

                PrimaryButton(title: isLastQuestion(totalQuestions: questions.count) ? "Continue" : "Next Question") {
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
        VStack(spacing: 14) {
            ProgressView()
            Text("Loading questions")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }

    private func errorView(message: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Could not load questions")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            PrimaryButton(title: "Try Again") {
                Task {
                    await viewModel.loadQuestions()
                }
            }
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

    private var emptyView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("No questions yet")
                .font(.headline)

            Text("Continue to the code task.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            PrimaryButton(title: "Continue") {
                router.push(.codeTask(lessonID: viewModel.lessonID))
            }
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

    private func feedbackView(_ answers: [LessonQuizAnswer]) -> some View {
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
        in answers: [LessonQuizAnswer]
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
            router.push(.codeTask(lessonID: viewModel.lessonID))
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
            dependencies: AppDependenciesAssembler.assemble()
        )
        .environment(AppRouter())
    }
}
