import SwiftUI

struct AnswerExplanationView: View {
    // MARK: - Public properties -

    let viewData: AnswerExplanationViewData

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: viewData.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(statusColor)

                Text(viewData.isCorrect ? L10n.string("answer.correct") : L10n.string("answer.incorrect"))
                    .font(.headline)
                    .foregroundStyle(statusColor)
            }

            if let correctAnswer = viewData.correctAnswer {
                Text(L10n.format("answer.correctAnswer", correctAnswer))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
            }

            Text(viewData.explanation)
                .font(.body)
                .foregroundStyle(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard(
            radius: AppRadius.largeCard,
            padding: AppSpacing.section
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(viewData.accessibilityLabel)
    }

    // MARK: - Private properties -

    private var statusColor: Color {
        viewData.isCorrect ? AppColors.success : AppColors.error
    }
}

#Preview {
    VStack(spacing: 12) {
        AnswerExplanationView(
            viewData: AnswerExplanationViewData(
                isCorrect: true,
                explanation: "Constants in Swift are declared with let.",
                correctAnswer: nil
            )
        )

        AnswerExplanationView(
            viewData: AnswerExplanationViewData(
                isCorrect: false,
                explanation: "Constants in Swift are declared with let.",
                correctAnswer: "let"
            )
        )
    }
    .padding()
    .background(AppColors.background)
}
