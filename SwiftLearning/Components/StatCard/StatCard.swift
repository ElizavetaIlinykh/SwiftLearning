import SwiftUI

struct StatCard: View {
    // MARK: - Public properties -

    let viewModel: StatCardViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: viewModel.systemImage)
                .font(.headline)
                .foregroundStyle(Color.accentColor)
                .frame(width: 34, height: 34)
                .background(Color.accentColor.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Text(viewModel.value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
}

#Preview {
    StatCard(
        viewModel: StatCardViewModel(
            title: "XP",
            value: "80",
            systemImage: "bolt.fill"
        )
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
