import SwiftUI

struct AnswerExplanationView: View {
    // MARK: - Public properties -

    let viewModel: AnswerExplanationViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: viewModel.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(statusColor)

                Text(viewModel.isCorrect ? L10n.string("answer.correct") : L10n.string("answer.incorrect"))
                    .font(.headline)
                    .foregroundStyle(statusColor)
            }

            if let correctAnswer = viewModel.correctAnswer {
                Text(L10n.format("answer.correctAnswer", correctAnswer))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }

            Text(viewModel.explanation)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard(
            radius: AppRadius.largeCard,
            padding: AppSpacing.section
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(viewModel.accessibilityLabel)
    }

    // MARK: - Private properties -

    private var statusColor: Color {
        viewModel.isCorrect ? .green : .red
    }
}

#Preview {
    VStack(spacing: 12) {
        AnswerExplanationView(
            viewModel: AnswerExplanationViewModel(
                isCorrect: true,
                explanation: "Constants in Swift are declared with let.",
                correctAnswer: nil
            )
        )

        AnswerExplanationView(
            viewModel: AnswerExplanationViewModel(
                isCorrect: false,
                explanation: "Constants in Swift are declared with let.",
                correctAnswer: "let"
            )
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
