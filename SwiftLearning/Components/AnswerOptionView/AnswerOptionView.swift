import SwiftUI

struct AnswerOptionView: View {
    // MARK: - Public properties -

    let viewModel: AnswerOptionViewModel
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(viewModel.title)
                    .font(.headline)
                    .foregroundStyle(textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let systemImageName {
                    Image(systemName: systemImageName)
                        .font(.headline)
                        .foregroundStyle(iconColor)
                }
            }
            .padding(16)
            .frame(minHeight: 58)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(borderColor, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Private properties -

    private var backgroundColor: Color {
        switch viewModel.state {
        case .neutral:
            Color(.secondarySystemGroupedBackground)
        case .selectedCorrect, .correct:
            Color.green.opacity(0.13)
        case .selectedIncorrect:
            Color.red.opacity(0.13)
        }
    }

    private var borderColor: Color {
        switch viewModel.state {
        case .neutral:
            Color.primary.opacity(0.08)
        case .selectedCorrect, .correct:
            Color.green.opacity(0.55)
        case .selectedIncorrect:
            Color.red.opacity(0.55)
        }
    }

    private var textColor: Color {
        switch viewModel.state {
        case .neutral:
            .primary
        case .selectedCorrect, .correct:
            .green
        case .selectedIncorrect:
            .red
        }
    }

    private var iconColor: Color {
        switch viewModel.state {
        case .selectedCorrect, .correct:
            .green
        case .selectedIncorrect:
            .red
        case .neutral:
            .secondary
        }
    }

    private var systemImageName: String? {
        switch viewModel.state {
        case .selectedCorrect, .correct:
            "checkmark.circle.fill"
        case .selectedIncorrect:
            "xmark.circle.fill"
        case .neutral:
            nil
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        AnswerOptionView(
            viewModel: AnswerOptionViewModel(
                title: "print()",
                state: .neutral
            )
        ) {}
        AnswerOptionView(
            viewModel: AnswerOptionViewModel(
                title: "print()",
                state: .selectedCorrect
            )
        ) {}
        AnswerOptionView(
            viewModel: AnswerOptionViewModel(
                title: "show()",
                state: .selectedIncorrect
            )
        ) {}
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
