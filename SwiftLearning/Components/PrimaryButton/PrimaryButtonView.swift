import SwiftUI

struct PrimaryButtonView: View {
    // MARK: - Public properties -

    let viewData: PrimaryButtonViewData
    let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Init -

    init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.init(
            viewData: PrimaryButtonViewData(title: title),
            action: action
        )
    }

    init(
        viewData: PrimaryButtonViewData,
        action: @escaping () -> Void
    ) {
        self.viewData = viewData
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(viewData.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(isEnabled ? AppColors.onPrimary : AppColors.textSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(isEnabled ? AppColors.buttonPrimary : AppColors.buttonDisabled)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PrimaryButtonView(title: "Start Learning") {}
        .padding()
}
