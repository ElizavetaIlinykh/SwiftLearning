import SwiftUI

struct QuizView: View {
    @EnvironmentObject private var progressStore: LearningProgressStore

    let lesson: Lesson
    let question: QuizQuestion
    let wasAlreadyCompleted: Bool
    let onFlowCompleted: () -> Void

    @State private var selectedAnswerIndex: Int?

    private var isAnswered: Bool {
        selectedAnswerIndex != nil
    }

    private var isCorrect: Bool {
        selectedAnswerIndex == question.correctAnswerIndex
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Quick Check")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(question.question)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
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

                    NavigationLink {
                        CodeChallengeView(
                            lesson: lesson,
                            challenge: lesson.challenge,
                            wasAlreadyCompleted: wasAlreadyCompleted,
                            onFlowCompleted: onFlowCompleted
                        )
                    } label: {
                        Text("Continue")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Color.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
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
        guard selectedAnswerIndex == nil else { return }

        selectedAnswerIndex = index
        progressStore.recordQuizAnswer(isCorrect: index == question.correctAnswerIndex)
    }
}

#Preview {
    NavigationStack {
        QuizView(
            lesson: LessonData.lessons[0],
            question: LessonData.lessons[0].quiz,
            wasAlreadyCompleted: false
        ) {}
        .environmentObject(LearningProgressStore())
    }
}
