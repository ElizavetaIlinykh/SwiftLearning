import SwiftUI

struct ErrorStateView: View {
    // MARK: - Public properties -

    let viewModel: ErrorStateViewModel
    let retryAction: () -> Void

    // MARK: - Init -

    init(
        title: String,
        message: String,
        retryTitle: String = L10n.string("common.tryAgain"),
        retryAction: @escaping () -> Void
    ) {
        self.init(
            viewModel: ErrorStateViewModel(
                title: title,
                message: message,
                retryTitle: retryTitle
            ),
            retryAction: retryAction
        )
    }

    init(
        viewModel: ErrorStateViewModel,
        retryAction: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.retryAction = retryAction
    }

    // MARK: - Public properties -

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(viewModel.title)
                .font(.headline)

            Text(viewModel.message)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            PrimaryButtonView(title: viewModel.retryTitle, action: retryAction)
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

#Preview {
    ErrorStateView(
        title: "Could not load lessons",
        message: "Something went wrong."
    ) {}
        .padding()
        .background(Color(.systemGroupedBackground))
}
