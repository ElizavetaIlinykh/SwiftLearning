import SwiftUI

struct PracticeCategoryCardView: View {
    // MARK: - Public properties -

    let viewData: PracticeCategoryCardViewData
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: viewData.systemImage)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(AppColors.primary)
                    .frame(width: 48, height: 48)
                    .appRoundedBackground(AppColors.primaryFill, radius: AppRadius.control)

                VStack(alignment: .leading, spacing: 6) {
                    Text(viewData.title)
                        .font(.headline)
                        .foregroundStyle(AppColors.textPrimary)

                    Text(viewData.description)
                        .font(.subheadline)
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.leading)

                    Text(viewData.tasksCountTitle)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.primary)
                }

                Spacer(minLength: 12)

                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .appCard(radius: AppRadius.largeCard)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PracticeCategoryCardView(
        viewData: PracticeCategoryCardViewData(
            id: "topic-uuid",
            title: "Variables and Constants",
            description: "Practice variables and constants",
            tasksCountTitle: "3 tasks",
            systemImage: "chevron.left.forwardslash.chevron.right"
        )
    ) {}
        .padding()
        .background(AppColors.background)
}
