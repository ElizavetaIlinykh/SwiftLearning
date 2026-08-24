import SwiftUI

struct LoadMoreView: View {
    enum State {
        case idle
        case loading
        case error(String)
    }

    // MARK: - Public properties -

    let viewModel: LoadMoreViewModel
    let retryAction: () async -> Void

    // MARK: - Init -

    init(
        state: State,
        retryTitle: String = "Try Again",
        retryAction: @escaping () async -> Void
    ) {
        self.init(
            viewModel: LoadMoreViewModel(
                state: state,
                retryTitle: retryTitle
            ),
            retryAction: retryAction
        )
    }

    init(
        viewModel: LoadMoreViewModel,
        retryAction: @escaping () async -> Void
    ) {
        self.viewModel = viewModel
        self.retryAction = retryAction
    }

    var body: some View {
        switch viewModel.state {
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
                    .foregroundStyle(.secondary)

                Button(viewModel.retryTitle) {
                    Task {
                        await retryAction()
                    }
                }
                .font(.headline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
        }
    }
}
