import SwiftUI

struct PracticeSessionView: View {
    let category: PracticeCategory
    let onDone: () -> Void

    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int?
    @State private var isAnswered = false
    @State private var correctAnswersCount = 0
    @State private var showResult = false

    private var question: PracticeQuestion {
        category.questions[currentQuestionIndex]
    }

    private var isLastQuestion: Bool {
        currentQuestionIndex == category.questions.count - 1
    }

    private var progress: Double {
        Double(currentQuestionIndex + 1) / Double(category.questions.count)
    }

    private var isCorrect: Bool {
        selectedAnswerIndex == question.correctAnswerIndex
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                questionProgress

                VStack(alignment: .leading, spacing: 14) {
                    Text(question.question)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)

                    if let code = question.code {
                        CodeBlockView(code: code)
                    }
                }

                VStack(spacing: 12) {
                    ForEach(question.answers.indices, id: \.self) { index in
                        AnswerOptionView(
                            title: question.answers[index],
                            state: optionState(for: index)
                        ) {
                            selectAnswer(index)
                        }
                        .disabled(isAnswered)
                    }
                }

                if isAnswered {
                    feedbackView

                    PrimaryButton(
                        title: isLastQuestion ? "See Results" : "Next Question",
                        action: advance
                    )
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(category.title)
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut(duration: 0.2), value: currentQuestionIndex)
        .navigationDestination(isPresented: $showResult) {
            PracticeResultView(
                category: category,
                correctAnswersCount: correctAnswersCount,
                totalQuestions: category.questions.count,
                onPracticeAgain: restart,
                onDone: onDone
            )
        }
    }

    private var questionProgress: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Question \(currentQuestionIndex + 1) of \(category.questions.count)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(category.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.accentColor)
            }

            ProgressView(value: progress)
                .tint(.accentColor)
        }
    }

    private var feedbackView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(isCorrect ? .green : .red)

                Text(isCorrect ? "Correct!" : "Not quite")
                    .font(.headline)
                    .foregroundStyle(isCorrect ? .green : .red)
            }

            Text(question.explanation)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(5)
                .multilineTextAlignment(.leading)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func optionState(for index: Int) -> AnswerOptionState {
        guard let selectedAnswerIndex else { return .neutral }

        if index == selectedAnswerIndex && index == question.correctAnswerIndex {
            return .selectedCorrect
        }

        if index == selectedAnswerIndex {
            return .selectedIncorrect
        }

        if index == question.correctAnswerIndex {
            return .correct
        }

        return .neutral
    }

    private func selectAnswer(_ index: Int) {
        guard !isAnswered else { return }

        selectedAnswerIndex = index
        isAnswered = true

        if index == question.correctAnswerIndex {
            correctAnswersCount += 1
        }
    }

    private func advance() {
        if isLastQuestion {
            showResult = true
        } else {
            currentQuestionIndex += 1
            selectedAnswerIndex = nil
            isAnswered = false
        }
    }

    private func restart() {
        currentQuestionIndex = 0
        selectedAnswerIndex = nil
        isAnswered = false
        correctAnswersCount = 0
        showResult = false
    }
}

#Preview {
    NavigationStack {
        PracticeSessionView(category: PracticeData.categories[0]) {}
    }
}
