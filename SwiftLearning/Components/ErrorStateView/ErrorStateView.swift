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
        .appCard(
            radius: AppRadius.largeCard,
            padding: AppSpacing.section
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
