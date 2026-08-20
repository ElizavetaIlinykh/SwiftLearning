import SwiftUI

struct ErrorStateView: View {
    // MARK: - Public properties -

    let title: String
    let message: String
    let retryTitle: String
    let retryAction: () -> Void

    // MARK: - Init -

    init(
        title: String,
        message: String,
        retryTitle: String = "Try Again",
        retryAction: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.retryTitle = retryTitle
        self.retryAction = retryAction
    }

    // MARK: - Public properties -

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            PrimaryButton(title: retryTitle, action: retryAction)
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
