import SwiftUI

struct ProgressCardView: View {
    // MARK: - Public properties -

    let viewModel: ProgressCardViewModel

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

            if viewModel.state == .completed {
                completedStateView
            }
        }
        .appCard(
            radius: AppRadius.largeCard,
            padding: AppSpacing.section
        )
    }

    // MARK: - Private properties -

    private var completedStateView: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)

            Text(L10n.string("learn.progress.courseCompleted"))
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.green)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 54)
        .appRoundedBackground(
            Color.green.opacity(AppOpacity.tintFill),
            radius: AppRadius.card
        )
    }
}

#Preview {
    ProgressCardView(
        viewModel: ProgressCardViewModel(
            courseTitle: "Swift Basics",
            completedLessonsTitle: "0 of 8 lessons completed",
            completedLessonsCount: 0,
            totalLessonsCount: 8,
            progress: 0,
            state: .notStarted
        )
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
