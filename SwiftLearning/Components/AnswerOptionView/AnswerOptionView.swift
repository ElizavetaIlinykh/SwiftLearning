import SwiftUI

struct AnswerOptionView: View {
    // MARK: - Public properties -

    let viewData: AnswerOptionViewData
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(viewData.title)
                    .font(.headline)
                    .foregroundStyle(textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let systemImageName {
                    Image(systemName: systemImageName)
                        .font(.headline)
                        .foregroundStyle(iconColor)
                }
            }
            .frame(minHeight: 58)
            .appCard(
                background: backgroundColor,
                borderColor: borderColor,
                lineWidth: 1.5
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Private properties -

    private var backgroundColor: Color {
        switch viewData.state {
        case .neutral:
            AppColors.card
        case .selectedCorrect, .correct:
            AppColors.successFill
        case .selectedIncorrect:
            AppColors.errorFill
        }
    }

    private var borderColor: Color {
        switch viewData.state {
        case .neutral:
            AppColors.border
        case .selectedCorrect, .correct:
            AppColors.success.opacity(AppOpacity.activeBorder)
        case .selectedIncorrect:
            AppColors.error.opacity(AppOpacity.activeBorder)
        }
    }

    private var textColor: Color {
        switch viewData.state {
        case .neutral:
            AppColors.textPrimary
        case .selectedCorrect, .correct:
            AppColors.success
        case .selectedIncorrect:
            AppColors.error
        }
    }

    private var iconColor: Color {
        switch viewData.state {
        case .selectedCorrect, .correct:
            AppColors.success
        case .selectedIncorrect:
            AppColors.error
        case .neutral:
            AppColors.textSecondary
        }
    }

    private var systemImageName: String? {
        switch viewData.state {
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
            viewData: AnswerOptionViewData(
                title: "print()",
                state: .neutral
            )
        ) {}
        AnswerOptionView(
            viewData: AnswerOptionViewData(
                title: "print()",
                state: .selectedCorrect
            )
        ) {}
        AnswerOptionView(
            viewData: AnswerOptionViewData(
                title: "show()",
                state: .selectedIncorrect
            )
        ) {}
    }
    .padding()
    .background(AppColors.background)
}
