import SwiftUI

struct AchievementCard: View {
    // MARK: - Public properties -

    let viewModel: AchievementCardViewModel

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: viewModel.systemImage)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(iconColor)
                .frame(width: 48, height: 48)
                .background(iconBackground)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

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
        .padding(16)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        )
        .opacity(viewModel.isUnlocked ? 1 : 0.68)
    }

    // MARK: - Private properties -

    private var iconColor: Color {
        viewModel.isUnlocked ? Color.accentColor : .secondary
    }

    private var iconBackground: Color {
        viewModel.isUnlocked ? Color.accentColor.opacity(0.12) : Color.secondary.opacity(0.10)
    }

    private var titleColor: Color {
        viewModel.isUnlocked ? .primary : .secondary
    }

    private var cardBackground: Color {
        viewModel.isUnlocked ? Color(.secondarySystemGroupedBackground) : Color.secondary.opacity(0.08)
    }

    private var borderColor: Color {
        viewModel.isUnlocked ? Color.primary.opacity(0.06) : Color.secondary.opacity(0.12)
    }
}

#Preview {
    VStack(spacing: 12) {
        AchievementCard(
            viewModel: AchievementCardViewModel(
                id: "first-step",
                title: "First Step",
                description: "Complete your first lesson",
                systemImage: "figure.walk",
                isUnlocked: true
            )
        )
        AchievementCard(
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
