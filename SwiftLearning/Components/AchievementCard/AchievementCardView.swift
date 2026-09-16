import SwiftUI

struct AchievementCardView: View {
    // MARK: - Public properties -

    let viewData: AchievementCardViewData

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: viewData.systemImage)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(iconColor)
                .frame(width: 48, height: 48)
                .background(iconBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.control, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                Text(viewData.title)
                    .font(.headline)
                    .foregroundStyle(titleColor)

                Text(viewData.description)
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 12)

            Image(systemName: viewData.isUnlocked ? "checkmark.circle.fill" : "lock.fill")
                .font(.headline)
                .foregroundStyle(viewData.isUnlocked ? AppColors.success : AppColors.textSecondary)
        }
        .appCard(
            background: cardBackground,
            borderColor: borderColor,
            radius: AppRadius.largeCard
        )
        .opacity(viewData.isUnlocked ? 1 : 0.68)
    }

    // MARK: - Private properties -

    private var iconColor: Color {
        viewData.isUnlocked ? AppColors.primary : AppColors.textSecondary
    }

    private var iconBackground: Color {
        viewData.isUnlocked ? AppColors.primaryFill : AppColors.disabledFill
    }

    private var titleColor: Color {
        viewData.isUnlocked ? AppColors.textPrimary : AppColors.textSecondary
    }

    private var cardBackground: Color {
        viewData.isUnlocked ? AppColors.card : AppColors.subtleFill
    }

    private var borderColor: Color {
        AppColors.border
    }
}

#Preview {
    VStack(spacing: 12) {
        AchievementCardView(
            viewData: AchievementCardViewData(
                id: "first-step",
                title: "First Step",
                description: "Complete your first lesson",
                systemImage: "figure.walk",
                isUnlocked: true
            )
        )
        AchievementCardView(
            viewData: AchievementCardViewData(
                id: "explorer",
                title: "Swift Explorer",
                description: "Complete all lessons",
                systemImage: "trophy.fill",
                isUnlocked: false
            )
        )
    }
    .padding()
    .background(AppColors.background)
}
