import SwiftUI

struct PracticeSessionView: View {
    // MARK: - Private properties -

    @StateObject private var viewModel: PracticeSessionViewModel

    // MARK: - Init -

    @State private var currentTaskIndex = 0
    @State private var selectedAnswerIndex: Int?
    @State private var isAnswered = false
    @State private var correctAnswersCount = 0
    @State private var totalAnswersCount = 0
    init(viewModel: PracticeSessionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Public properties -

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
            await refreshTasks()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingView
        case let .failed(message):
            errorView(message: message)
        case .loaded:
            if viewModel.tasks.isEmpty {
                emptyView
            } else {
                taskContent(viewModel.tasks)
            }
        }
    }

    // MARK: - Private methods -

    private func taskContent(_ tasks: [PracticeTask]) -> some View {
        let safeTaskIndex = min(currentTaskIndex, tasks.count - 1)
        let task = tasks[safeTaskIndex]
        let answers = task.answers.sorted { $0.order < $1.order }

        return VStack(alignment: .leading, spacing: 22) {
            taskProgress(totalTasks: tasks.count)
                .onAppear {
                    Task {
                        await viewModel.loadMoreTasksIfNeeded(currentTaskID: task.id)
                    }
                }

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
                completionErrorView
                loadMoreTasksView

                PrimaryButton(
                    title: actionButtonTitle(totalTasks: tasks.count),
                    action: {
                        Task {
                            await advance(totalTasks: tasks.count)
                        }
                    }
                )
                .disabled(isSavingResult || viewModel.isLoadingMoreTasks)
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

    @ViewBuilder
    private var completionErrorView: some View {
        if case let .failed(message) = viewModel.completionState {
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private var loadMoreTasksView: some View {
        if viewModel.isLoadingMoreTasks {
            ProgressView()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        } else if let message = viewModel.loadMoreTasksError {
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
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
        ErrorStateView(
            title: "Could not load tasks",
            message: message
        ) {
            Task {
                await viewModel.loadTasks()
            }
        }
    }

    private var emptyView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("No tasks yet")
                .font(.headline)

            Text("Tasks will appear here when the server returns them.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button("Done") {
                viewModel.closePractice()
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

    private func refreshTasks() async {
        currentTaskIndex = 0
        selectedAnswerIndex = nil
        isAnswered = false
        correctAnswersCount = 0
        totalAnswersCount = 0
        await viewModel.loadTasks()
    }

    private func optionState(
        for index: Int,
        in answers: [PracticeAnswer]
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

    private func selectAnswer(
        _ index: Int,
        in answers: [PracticeAnswer]
    ) {
        guard !isAnswered else { return }

        selectedAnswerIndex = index
        isAnswered = true
        totalAnswersCount += 1

        if answers[index].isCorrect {
            correctAnswersCount += 1
        }
    }

    private func advance(totalTasks: Int) async {
        if isLastTask(totalTasks: totalTasks), viewModel.hasMoreTasks {
            let previousTaskCount = viewModel.tasks.count
            await viewModel.loadMoreTasks()

            if viewModel.tasks.count > previousTaskCount {
                moveToNextTask()
            } else if !viewModel.hasMoreTasks {
                await saveResult()
            }
            return
        }

        if isLastTask(totalTasks: totalTasks) {
            await saveResult()
        } else {
            moveToNextTask()
        }
    }

    private func moveToNextTask() {
        currentTaskIndex += 1
        selectedAnswerIndex = nil
        isAnswered = false
    }

    private func saveResult() async {
        guard let progress = await viewModel.saveResult(
            correctAnswersCount: correctAnswersCount,
            totalAnswersCount: totalAnswersCount
        ) else {
            return
        }

        viewModel.openResult(progress: progress)
    }

    private func actionButtonTitle(totalTasks: Int) -> String {
        if isSavingResult {
            return "Saving..."
        }

        if viewModel.isLoadingMoreTasks {
            return "Loading..."
        }

        return isLastTask(totalTasks: totalTasks) && !viewModel.hasMoreTasks ? "See Results" : "Next Question"
    }

    private var isSavingResult: Bool {
        if case .saving = viewModel.completionState {
            return true
        }
        return false
    }

    private func isLastTask(totalTasks: Int) -> Bool {
        currentTaskIndex == totalTasks - 1
    }
}

#Preview {
    let router = AppRouter()

    NavigationStack {
        PracticeModuleAssembler.assembleSession(
            topicID: "topic-uuid",
            topicTitle: "Variables and Constants",
            dependencies: AppDependenciesAssembler.assemble(),
            router: router
        )
        .environment(router)
    }
}
