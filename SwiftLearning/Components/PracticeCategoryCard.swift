import SwiftUI

struct PracticeCategoryCard: View {
    let category: PracticeCategory
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: category.systemImage)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 48, height: 48)
                    .background(Color.accentColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

                VStack(alignment: .leading, spacing: 6) {
                    Text(category.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(category.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)

                    Text("\(category.tasksCount) tasks")
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
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PracticeCategoryCard(
        category: PracticeCategory(
            id: "topic-uuid",
            title: "Variables and Constants",
            description: "Practice variables and constants",
            order: 1,
            tasksCount: 3
        )
    ) {}
        .padding()
        .background(Color(.systemGroupedBackground))
}
