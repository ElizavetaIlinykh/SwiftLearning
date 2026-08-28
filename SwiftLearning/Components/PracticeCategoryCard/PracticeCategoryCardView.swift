import SwiftUI

struct PracticeCategoryCardView: View {
    // MARK: - Public properties -

    let viewModel: PracticeCategoryCardViewModel
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: viewModel.systemImage)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 48, height: 48)
                    .appRoundedBackground(AppColors.accentFill, radius: AppRadius.control)

                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(viewModel.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)

                    Text(viewModel.tasksCountTitle)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accentColor)
                }

                Spacer(minLength: 12)

                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
            }
            .appCard(radius: AppRadius.largeCard)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PracticeCategoryCardView(
        viewModel: PracticeCategoryCardViewModel(
            id: "topic-uuid",
            title: "Variables and Constants",
            description: "Practice variables and constants",
            tasksCountTitle: "3 tasks",
            systemImage: "chevron.left.forwardslash.chevron.right"
        )
    ) {}
        .padding()
        .background(Color(.systemGroupedBackground))
}
