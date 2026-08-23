import SwiftUI

struct LoadingStateView: View {
    let title: String

    var body: some View {
        VStack(spacing: 14) {
            ProgressView()

            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}

#Preview {
    LoadingStateView(title: "Loading")
        .padding(20)
        .background(Color(.systemGroupedBackground))
}
