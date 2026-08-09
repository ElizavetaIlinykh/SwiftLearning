import SwiftUI

struct CodeChallengeView: View {
    @EnvironmentObject private var progressStore: LearningProgressStore

    let lesson: Lesson
    let challenge: CodeChallenge
    let wasAlreadyCompleted: Bool
    let onFlowCompleted: () -> Void

    @State private var selectedOptionIndex: Int?
    @State private var challengeCompleted = false
    @State private var showCompletion = false

    private var didChooseIncorrectAnswer: Bool {
        if let selectedOptionIndex {
            return selectedOptionIndex != challenge.correctAnswerIndex && !challengeCompleted
        }

        return false
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Code Challenge")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(challenge.title)
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text(challenge.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(challengeCompleted ? "COMPLETED CODE" : "COMPLETE THE CODE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)

                    CodeBlockView(code: challengeCompleted ? challenge.completedCode : challenge.codeTemplate)
                }

                VStack(spacing: 12) {
                    ForEach(challenge.options.indices, id: \.self) { index in
                        AnswerOptionView(
                            title: challenge.options[index],
                            state: optionState(for: index)
                        ) {
                            selectOption(index)
                        }
                        .disabled(challengeCompleted)
                    }
                }

                if didChooseIncorrectAnswer {
                    Text("Try again")
                        .font(.headline)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if challengeCompleted {
                    successView

                    Button {
                        progressStore.completeLesson(lesson)
                        showCompletion = true
                    } label: {
                        Text("Finish Lesson")
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
        .navigationTitle("Challenge")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showCompletion) {
            LessonCompletedView(
                lesson: lesson,
                didEarnXP: !wasAlreadyCompleted,
                onContinue: onFlowCompleted
            )
        }
    }

    private var successView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)

                Text("Great job!")
                    .font(.headline)
                    .foregroundStyle(.green)
            }

            Text("You completed the challenge.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func optionState(for index: Int) -> AnswerOptionState {
        guard let selectedOptionIndex else { return .neutral }

        if challengeCompleted && index == challenge.correctAnswerIndex {
            return .selectedCorrect
        }

        if index == selectedOptionIndex && index == challenge.correctAnswerIndex {
            return .selectedCorrect
        }

        if index == selectedOptionIndex {
            return .selectedIncorrect
        }

        return .neutral
    }

    private func selectOption(_ index: Int) {
        guard !challengeCompleted else { return }

        selectedOptionIndex = index

        if index == challenge.correctAnswerIndex {
            challengeCompleted = true
        }
    }
}

#Preview {
    NavigationStack {
        CodeChallengeView(
            lesson: LessonData.lessons[0],
            challenge: LessonData.lessons[0].challenge,
            wasAlreadyCompleted: false
        ) {}
        .environmentObject(LearningProgressStore())
    }
}
