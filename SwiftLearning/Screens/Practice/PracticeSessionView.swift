import SwiftUI

struct PracticeSessionView: View {
    @Environment(AppRouter.self) private var router
    @StateObject private var viewModel: PracticeSessionViewModel

    @State private var currentTaskIndex = 0
    @State private var selectedAnswerIndex: Int?
    @State private var isAnswered = false
    @State private var correctAnswersCount = 0

    init(viewModel: PracticeSessionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                content
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.topicTitle)
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut(duration: 0.2), value: currentTaskIndex)
        .task {
            await viewModel.loadTasks()
        }
        .refreshable {
            await viewModel.loadTasks()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingView
        case .failed(let message):
            errorView(message: message)
        case .loaded:
            if viewModel.tasks.isEmpty {
                emptyView
            } else {
                taskContent(viewModel.tasks)
            }
        }
    }

    private func taskContent(_ tasks: [PracticeTask]) -> some View {
        let task = tasks[currentTaskIndex]
        let answers = task.answers.sorted { $0.order < $1.order }

        return VStack(alignment: .leading, spacing: 22) {
            taskProgress(totalTasks: tasks.count)

            VStack(alignment: .leading, spacing: 14) {
                Text(task.question)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)

                if let code = task.code {
                    CodeBlockView(code: code)
                }
            }

            VStack(spacing: 12) {
                ForEach(answers.indices, id: \.self) { index in
                    AnswerOptionView(
                        title: answers[index].text,
                        state: optionState(for: index, in: answers)
                    ) {
                        selectAnswer(index, in: answers)
                    }
                    .disabled(isAnswered)
                }
            }

            if isAnswered {
                feedbackView(answers)

                PrimaryButton(
                    title: isLastTask(totalTasks: tasks.count) ? "See Results" : "Next Question",
                    action: {
                        advance(totalTasks: tasks.count)
                    }
                )
            }
        }
    }

    private func taskProgress(totalTasks: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Question \(currentTaskIndex + 1) of \(totalTasks)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(viewModel.topicTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.accentColor)
            }

            ProgressView(value: Double(currentTaskIndex + 1) / Double(totalTasks))
                .tint(.accentColor)
        }
    }

    private func feedbackView(_ answers: [PracticeAnswer]) -> some View {
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

    private var loadingView: some View {
        VStack(spacing: 14) {
            ProgressView()
            Text("Loading tasks")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }

    private func errorView(message: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Could not load tasks")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            PrimaryButton(title: "Try Again") {
                Task {
                    await viewModel.loadTasks()
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
            Text("No tasks yet")
                .font(.headline)

            Text("Tasks will appear here when the server returns them.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button("Done") {
                router.popPracticeToRoot()
            }
            .font(.headline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
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

    private func optionState(
        for index: Int,
        in answers: [PracticeAnswer]
    ) -> AnswerOptionState {
        guard let selectedAnswerIndex else { return .neutral }

        if index == selectedAnswerIndex && answers[index].isCorrect {
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

    private func selectAnswer(
        _ index: Int,
        in answers: [PracticeAnswer]
    ) {
        guard !isAnswered else { return }

        selectedAnswerIndex = index
        isAnswered = true

        if answers[index].isCorrect {
            correctAnswersCount += 1
        }
    }

    private func advance(totalTasks: Int) {
        if isLastTask(totalTasks: totalTasks) {
            router.push(
                .result(
                    topicID: viewModel.topicID,
                    topicTitle: viewModel.topicTitle,
                    correctAnswersCount: correctAnswersCount,
                    totalQuestions: totalTasks
                )
            )
        } else {
            currentTaskIndex += 1
            selectedAnswerIndex = nil
            isAnswered = false
        }
    }

    private func isLastTask(totalTasks: Int) -> Bool {
        currentTaskIndex == totalTasks - 1
    }
}

#Preview {
    NavigationStack {
        PracticeModuleAssembler.assembleSession(
            topicID: "topic-uuid",
            topicTitle: "Variables and Constants",
            dependencies: AppDependenciesAssembler.assemble()
        )
        .environment(AppRouter())
    }
}
