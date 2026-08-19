import SwiftUI

enum AnswerOptionState {
    case neutral
    case selectedCorrect
    case selectedIncorrect
    case correct
}

struct AnswerOptionView: View {
    let title: String
    let state: AnswerOptionState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(title)
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

    private var backgroundColor: Color {
        switch state {
        case .neutral:
            Color(.secondarySystemGroupedBackground)
        case .selectedCorrect, .correct:
            Color.green.opacity(0.13)
        case .selectedIncorrect:
            Color.red.opacity(0.13)
        }
    }

    private var borderColor: Color {
        switch state {
        case .neutral:
            Color.primary.opacity(0.08)
        case .selectedCorrect, .correct:
            Color.green.opacity(0.55)
        case .selectedIncorrect:
            Color.red.opacity(0.55)
        }
    }

    private var textColor: Color {
        switch state {
        case .neutral:
            .primary
        case .selectedCorrect, .correct:
            .green
        case .selectedIncorrect:
            .red
        }
    }

    private var iconColor: Color {
        switch state {
        case .selectedCorrect, .correct:
            .green
        case .selectedIncorrect:
            .red
        case .neutral:
            .secondary
        }
    }

    private var systemImageName: String? {
        switch state {
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
        AnswerOptionView(title: "print()", state: .neutral) {}
        AnswerOptionView(title: "print()", state: .selectedCorrect) {}
        AnswerOptionView(title: "show()", state: .selectedIncorrect) {}
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
