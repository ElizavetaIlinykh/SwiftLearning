import SwiftUI

struct RoutePlaceholderView: View {
    // MARK: - Public properties -

    let title: String

    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(AppColors.textPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
}
