import SwiftUI

struct StatCardView: View {
    // MARK: - Public properties -

    let viewModel: StatCardViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: viewModel.systemImage)
                .font(.headline)
                .foregroundStyle(AppColors.primary)
                .frame(width: 34, height: 34)
                .appRoundedBackground(AppColors.primaryFill, radius: AppRadius.field)

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textSecondary)

                Text(viewModel.value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.textPrimary)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard(radius: AppRadius.largeCard)
    }
}

#Preview {
    StatCardView(
        viewModel: StatCardViewModel(
            title: "XP",
            value: "80",
            systemImage: "bolt.fill"
        )
    )
    .padding()
    .background(AppColors.background)
}
