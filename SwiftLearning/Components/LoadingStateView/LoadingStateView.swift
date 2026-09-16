import SwiftUI

struct LoadingStateView: View {
    let viewData: LoadingStateViewData

    init(title: String) {
        self.init(viewData: LoadingStateViewData(title: title))
    }

    init(viewData: LoadingStateViewData) {
        self.viewData = viewData
    }

    var body: some View {
        VStack(spacing: 14) {
            ProgressView()

            Text(viewData.title)
                .font(.headline)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}

#Preview {
    LoadingStateView(title: "Loading")
        .padding(20)
        .background(AppColors.background)
}
