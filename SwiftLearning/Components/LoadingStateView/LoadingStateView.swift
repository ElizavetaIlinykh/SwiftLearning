import SwiftUI

struct LoadingStateView: View {
    let viewModel: LoadingStateViewModel

    init(title: String) {
        self.init(viewModel: LoadingStateViewModel(title: title))
    }

    init(viewModel: LoadingStateViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 14) {
            ProgressView()

            Text(viewModel.title)
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
