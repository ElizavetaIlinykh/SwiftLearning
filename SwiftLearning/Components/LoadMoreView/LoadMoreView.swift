import SwiftUI

struct LoadMoreView: View {
    enum State {
        case idle
        case loading
        case error(String)
    }

    // MARK: - Public properties -

    let viewData: LoadMoreViewData
    let retryAction: () async -> Void

    // MARK: - Init -

    init(
        state: State,
        retryTitle: String = L10n.string("common.tryAgain"),
        retryAction: @escaping () async -> Void
    ) {
        self.init(
            viewData: LoadMoreViewData(
                state: state,
                retryTitle: retryTitle
            ),
            retryAction: retryAction
        )
    }

    init(
        viewData: LoadMoreViewData,
        retryAction: @escaping () async -> Void
    ) {
        self.viewData = viewData
        self.retryAction = retryAction
    }

    var body: some View {
        switch viewData.state {
        case .idle:
            EmptyView()

        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)

        case let .error(message):
            VStack(alignment: .leading, spacing: 8) {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)

                Button(viewData.retryTitle) {
                    Task {
                        await retryAction()
                    }
                }
                .font(.headline)
                .foregroundStyle(AppColors.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
        }
    }
}
