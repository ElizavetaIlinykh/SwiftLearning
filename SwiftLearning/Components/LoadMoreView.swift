import SwiftUI

struct LoadMoreView: View {
    enum State {
        case idle
        case loading
        case error(String)
    }

    // MARK: - Public properties -

    let state: State
    let retryTitle: String
    let retryAction: () async -> Void

    // MARK: - Init -

    init(
        state: State,
        retryTitle: String = "Try Again",
        retryAction: @escaping () async -> Void
    ) {
        self.state = state
        self.retryTitle = retryTitle
        self.retryAction = retryAction
    }

    var body: some View {
        switch state {
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

                Button(retryTitle) {
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
