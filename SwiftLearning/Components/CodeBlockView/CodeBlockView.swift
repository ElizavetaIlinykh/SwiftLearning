import SwiftUI

struct CodeBlockView: View {
    // MARK: - Public properties -

    let viewModel: CodeBlockViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(viewModel.code)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(Color.white.opacity(0.94))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(AppSpacing.section)
        }
        .background(Color(red: 0.10, green: 0.11, blue: 0.13))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous))
    }
}

#Preview {
    CodeBlockView(
        viewModel: CodeBlockViewModel(code: "print(\"Hello, Swift!\")")
    )
    .padding()
}
