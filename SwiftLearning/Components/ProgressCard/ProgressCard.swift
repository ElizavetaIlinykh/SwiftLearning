import SwiftUI

struct ProgressCard: View {
    // MARK: - Public properties -

    let viewModel: ProgressCardViewModel
    let onAction: (ProgressCardAction) -> Void

    // MARK: - Public properties -

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.courseTitle)
                    .font(.title3)
                    .fontWeight(.bold)

                Text(viewModel.completedLessonsTitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: viewModel.progress)
                .tint(.accentColor)

            footer
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }

    // MARK: - Private properties -

    @ViewBuilder
    private var footer: some View {
        switch viewModel.state {
        case .completed:
            HStack(spacing: 10) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)

                Text("Course Completed")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color.green.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

        case .notStarted:
            PrimaryButton(title: "Start Learning") {
                onAction(.startLearning)
            }

        case .inProgress:
            PrimaryButton(title: "Continue Learning") {
                onAction(.continueLearning)
            }
        }
    }
}

#Preview {
    ProgressCard(
        viewModel: ProgressCardViewModel(
            courseTitle: "Swift Basics",
            completedLessonsTitle: "0 of 8 lessons completed",
            completedLessonsCount: 0,
            totalLessonsCount: 8,
            progress: 0,
            state: .notStarted
        ),
        onAction: { _ in }
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
