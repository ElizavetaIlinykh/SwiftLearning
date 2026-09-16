import SwiftUI

struct CodeBlockView: View {
    // MARK: - Public properties -

    let viewData: CodeBlockViewData

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(viewData.code)
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
        viewData: CodeBlockViewData(code: "print(\"Hello, Swift!\")")
    )
    .padding()
}
