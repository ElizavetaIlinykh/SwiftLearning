import SwiftUI

struct AchievementCardView: View {
    // MARK: - Public properties -

    let viewModel: AchievementCardViewModel

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: viewModel.systemImage)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(iconColor)
                .frame(width: 48, height: 48)
                .background(iconBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.control, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                Text(viewModel.title)
                    .font(.headline)
                    .foregroundStyle(titleColor)

                Text(viewModel.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 12)

            Image(systemName: viewModel.isUnlocked ? "checkmark.circle.fill" : "lock.fill")
                .font(.headline)
                .foregroundStyle(viewModel.isUnlocked ? .green : .secondary)
        }
        .appCard(
            background: cardBackground,
            borderColor: borderColor,
            radius: AppRadius.largeCard
        )
        .opacity(viewModel.isUnlocked ? 1 : 0.68)
    }

    // MARK: - Private properties -

    private var iconColor: Color {
        viewModel.isUnlocked ? Color.accentColor : .secondary
    }

    private var iconBackground: Color {
        viewModel.isUnlocked ? AppColors.accentFill : AppColors.secondaryBorder
    }

    private var titleColor: Color {
        viewModel.isUnlocked ? .primary : .secondary
    }

    private var cardBackground: Color {
        viewModel.isUnlocked ? AppColors.cardBackground : AppColors.secondaryFill
    }

    private var borderColor: Color {
        viewModel.isUnlocked ? AppColors.hairlineBorder : AppColors.secondaryBorder
    }
}

#Preview {
    VStack(spacing: 12) {
        AchievementCardView(
            viewModel: AchievementCardViewModel(
                id: "first-step",
                title: "First Step",
                description: "Complete your first lesson",
                systemImage: "figure.walk",
                isUnlocked: true
            )
        )
        AchievementCardView(
            viewModel: AchievementCardViewModel(
                id: "explorer",
                title: "Swift Explorer",
                description: "Complete all lessons",
                systemImage: "trophy.fill",
                isUnlocked: false
            )
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
