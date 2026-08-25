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
            "Perfect!"
        case 80 ... 99:
            "Great work!"
        case 60 ... 79:
            "Good progress!"
        default:
            "Keep practicing!"
        }
    }

    var body: some View {
        VStack(spacing: 26) {
            Spacer()

            Image(systemName: progress.scorePercent >= 60 ? "checkmark.circle.fill" : "arrow.clockwise.circle.fill")
                .font(.system(size: 74, weight: .semibold))
                .foregroundStyle(progress.scorePercent >= 60 ? .green : Color.accentColor)

            VStack(spacing: 10) {
                Text("Practice Complete")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(topicTitle)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 8) {
                Text("\(progress.correctAnswersCount) / \(progress.totalAnswersCount)")
                    .font(.system(size: 54, weight: .bold, design: .rounded))

                Text("\(progress.scorePercent)% correct")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Text(resultMessage)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.accentColor)
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
            )

            Spacer()

            VStack(spacing: 12) {
                PrimaryButtonView(title: "Practice Again") {
                    onAction(.practiceAgain)
                }

                Button("Done") {
                    onAction(.done)
                }
                .font(.headline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
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
