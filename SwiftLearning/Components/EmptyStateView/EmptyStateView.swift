import SwiftUI

struct EmptyStateView<Action: View>: View {
    // MARK: - Public properties -

    let viewModel: EmptyStateViewModel
    @ViewBuilder let action: Action

    init(
        viewModel: EmptyStateViewModel,
        @ViewBuilder action: () -> Action
    ) {
        self.viewModel = viewModel
        self.action = action()
    }

    init(
        title: String,
        message: String,
        @ViewBuilder action: () -> Action
    ) {
        self.init(
            viewModel: EmptyStateViewModel(
                title: title,
                message: message
            ),
            action: action
        )
    }

    // MARK: - Public properties -

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.title)
                    .font(.headline)

                Text(viewModel.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            action
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
}

extension EmptyStateView where Action == EmptyView {
    init(
        title: String,
        message: String
    ) {
        self.init(
            viewModel: EmptyStateViewModel(
                title: title,
                message: message
            )
        ) {
            EmptyView()
        }
    }
}

#Preview {
    EmptyStateView(
        title: "No lessons yet",
        message: "Lessons will appear here when the server returns them."
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
