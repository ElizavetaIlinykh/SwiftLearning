import SwiftUI

struct PracticeResultView: View {
    let category: PracticeCategory
    let correctAnswersCount: Int
    let totalQuestions: Int
    let onPracticeAgain: () -> Void
    let onDone: () -> Void

    private var percentage: Int {
        guard totalQuestions > 0 else { return 0 }
        return Int((Double(correctAnswersCount) / Double(totalQuestions)) * 100)
    }

    private var resultMessage: String {
        switch correctAnswersCount {
        case totalQuestions:
            return "Perfect!"
        case totalQuestions - 1:
            return "Great work!"
        case 3:
            return "Good progress!"
        default:
            return "Keep practicing!"
        }
    }

    var body: some View {
        VStack(spacing: 26) {
            Spacer()

            Image(systemName: correctAnswersCount >= 3 ? "checkmark.circle.fill" : "arrow.clockwise.circle.fill")
                .font(.system(size: 74, weight: .semibold))
                .foregroundStyle(correctAnswersCount >= 3 ? .green : Color.accentColor)

            VStack(spacing: 10) {
                Text("Practice Complete")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(category.title)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 8) {
                Text("\(correctAnswersCount) / \(totalQuestions)")
                    .font(.system(size: 54, weight: .bold, design: .rounded))

                Text("\(percentage)% correct")
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
                PrimaryButton(title: "Practice Again", action: onPracticeAgain)

                Button("Done", action: onDone)
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
        category: PracticeData.categories[0],
        correctAnswersCount: 4,
        totalQuestions: 5
    ) {} onDone: {}
}
