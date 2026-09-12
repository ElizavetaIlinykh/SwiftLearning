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
                    .foregroundStyle(AppColors.textPrimary)

                Text(viewModel.completedLessonsTitle)
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
            }

            AppProgressBarView(value: viewModel.progress)

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
                .foregroundStyle(AppColors.success)

            Text(L10n.string("learn.progress.courseCompleted"))
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.success)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 54)
        .appRoundedBackground(
            AppColors.successFill,
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
    .background(AppColors.background)
}
