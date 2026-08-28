import SwiftUI

struct PrimaryButtonView: View {
    // MARK: - Public properties -

    let viewModel: PrimaryButtonViewModel
    let action: () -> Void

    // MARK: - Init -

    init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.init(
            viewModel: PrimaryButtonViewModel(title: title),
            action: action
        )
    }

    init(
        viewModel: PrimaryButtonViewModel,
        action: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(viewModel.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PrimaryButtonView(title: "Start Learning") {}
        .padding()
}
