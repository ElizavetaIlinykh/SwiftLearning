import SwiftUI

struct CodeBlockView: View {
    // MARK: - Public properties -

    let viewModel: CodeBlockViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(viewModel.code)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(AppColors.codeText)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(AppSpacing.section)
        }
        .background(AppColors.codeBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous))
    }
}

#Preview {
    CodeBlockView(
        viewModel: CodeBlockViewModel(code: "print(\"Hello, Swift!\")")
    )
    .padding()
}
