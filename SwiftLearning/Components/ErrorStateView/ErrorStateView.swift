import SwiftUI

struct ErrorStateView: View {
    // MARK: - Public properties -

    let viewData: ErrorStateViewData
    let retryAction: () -> Void

    // MARK: - Init -

    init(
        title: String,
        message: String,
        retryTitle: String = L10n.string("common.tryAgain"),
        retryAction: @escaping () -> Void
    ) {
        self.init(
            viewData: ErrorStateViewData(
                title: title,
                message: message,
                retryTitle: retryTitle
            ),
            retryAction: retryAction
        )
    }

    init(
        viewData: ErrorStateViewData,
        retryAction: @escaping () -> Void
    ) {
        self.viewData = viewData
        self.retryAction = retryAction
    }

    // MARK: - Public properties -

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(viewData.title)
                .font(.headline)

            Text(viewData.message)
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary)

            PrimaryButtonView(title: viewData.retryTitle, action: retryAction)
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
        .background(AppColors.background)
}
