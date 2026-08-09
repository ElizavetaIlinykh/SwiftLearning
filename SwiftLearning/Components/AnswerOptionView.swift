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
            return Color(.secondarySystemGroupedBackground)
        case .selectedCorrect, .correct:
            return Color.green.opacity(0.13)
        case .selectedIncorrect:
            return Color.red.opacity(0.13)
        }
    }

    private var borderColor: Color {
        switch state {
        case .neutral:
            return Color.primary.opacity(0.08)
        case .selectedCorrect, .correct:
            return Color.green.opacity(0.55)
        case .selectedIncorrect:
            return Color.red.opacity(0.55)
        }
    }

    private var textColor: Color {
        switch state {
        case .neutral:
            return .primary
        case .selectedCorrect, .correct:
            return .green
        case .selectedIncorrect:
            return .red
        }
    }

    private var iconColor: Color {
        switch state {
        case .selectedCorrect, .correct:
            return .green
        case .selectedIncorrect:
            return .red
        case .neutral:
            return .secondary
        }
    }

    private var systemImageName: String? {
        switch state {
        case .selectedCorrect, .correct:
            return "checkmark.circle.fill"
        case .selectedIncorrect:
            return "xmark.circle.fill"
        case .neutral:
            return nil
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
