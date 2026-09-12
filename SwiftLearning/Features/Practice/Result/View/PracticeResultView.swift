import SwiftUI

enum PracticeResultAction {
    case practiceAgain
    case done
}

struct PracticeResultView: View {
    // MARK: - Public properties -

    let topicTitle: String
    let progress: PracticeProgress
    let onAction: (PracticeResultAction) -> Void

    // MARK: - Private properties -

    private var resultMessage: String {
        switch progress.scorePercent {
        case 100:
            L10n.string("practice.result.perfect")
        case 80 ... 99:
            L10n.string("practice.result.great")
        case 60 ... 79:
            L10n.string("practice.result.good")
        default:
            L10n.string("practice.result.keepPracticing")
        }
    }

    var body: some View {
        VStack(spacing: 26) {
            Spacer()

            Image(systemName: progress.scorePercent >= 60 ? "checkmark.circle.fill" : "arrow.clockwise.circle.fill")
                .font(.system(size: 74, weight: .semibold))
                .foregroundStyle(progress.scorePercent >= 60 ? AppColors.success : AppColors.primary)

            VStack(spacing: 10) {
                Text(L10n.string("practice.result.title"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(topicTitle)
                    .font(.headline)
                    .foregroundStyle(AppColors.textSecondary)
            }

            VStack(spacing: 8) {
                Text("\(progress.correctAnswersCount) / \(progress.totalAnswersCount)")
                    .font(.system(size: 54, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.textPrimary)

                Text(L10n.format("practice.result.correctPercent", progress.scorePercent))
                    .font(.headline)
                    .foregroundStyle(AppColors.textSecondary)

                Text(resultMessage)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.primary)
            }
            .frame(maxWidth: .infinity)
            .appCard(
                radius: AppRadius.largeCard,
                padding: AppSpacing.expandedScreen
            )

            Spacer()

            VStack(spacing: 12) {
                PrimaryButtonView(title: L10n.string("practice.result.practiceAgain")) {
                    onAction(.practiceAgain)
                }

                Button(L10n.string("common.done")) {
                    onAction(.done)
                }
                .appSecondaryButton()
            }
        }
        .padding(AppSpacing.expandedScreen)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PracticeResultView(
        topicTitle: "Variables and Constants",
        progress: PracticeProgress(
            topicId: "topic-uuid",
            correctAnswersCount: 4,
            totalAnswersCount: 5,
            scorePercent: 80,
            completedAt: Date()
        )
    ) { _ in }
}
