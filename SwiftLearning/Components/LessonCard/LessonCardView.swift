import SwiftUI

struct LessonCardView: View {
    // MARK: - Public properties -

    let viewModel: LessonCardViewModel
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(String(format: "%02d", viewModel.order))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(numberColor)
                    .frame(width: 44, height: 44)
                    .appRoundedBackground(numberBackground, radius: AppRadius.control)

                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.title)
                        .font(.headline)
                        .foregroundStyle(titleColor)

                    Text(viewModel.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 12)

                stateView
            }
            .appCard(
                background: cardBackground,
                borderColor: borderColor,
                radius: AppRadius.largeCard,
                lineWidth: viewModel.state == .current ? 1.5 : 1
            )
            .opacity(viewModel.state == .locked ? 0.62 : 1)
        }
        .buttonStyle(.plain)
        .disabled(viewModel.state == .locked)
    }

    // MARK: - Private properties -

    @ViewBuilder
    private var stateView: some View {
        switch viewModel.state {
        case .completed:
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundStyle(.green)
        case .current:
            HStack(spacing: 6) {
                Text(viewModel.actionTitle)
                    .font(.caption)
                    .fontWeight(.semibold)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundStyle(Color.accentColor)
        case .locked:
            Image(systemName: "lock.fill")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var cardBackground: Color {
        switch viewModel.state {
        case .completed:
            Color.green.opacity(AppOpacity.subtleFill)
        case .current:
            AppColors.accentFill
        case .locked:
            AppColors.secondaryFill
        }
    }

    private var borderColor: Color {
        switch viewModel.state {
        case .completed:
            Color.green.opacity(0.22)
        case .current:
            Color.accentColor.opacity(AppOpacity.activeBorder)
        case .locked:
            AppColors.secondaryBorder
        }
    }

    private var numberColor: Color {
        viewModel.state == .locked ? .secondary : .accentColor
    }

    private var titleColor: Color {
        viewModel.state == .locked ? .secondary : .primary
    }

    private var numberBackground: Color {
        viewModel.state == .locked ? AppColors.secondaryBorder : AppColors.accentSelectedFill
    }
}

#Preview {
    VStack(spacing: 12) {
        LessonCardView(
            viewModel: LessonCardViewModel(
                id: "1",
                title: "Variables",
                description: "Basics",
                order: 1,
                state: .current,
                actionTitle: "Start"
            )
        ) {}
        LessonCardView(
            viewModel: LessonCardViewModel(
                id: "2",
                title: "Conditions",
                description: "Control flow",
                order: 2,
                state: .locked,
                actionTitle: "Continue"
            )
        ) {}
        LessonCardView(
            viewModel: LessonCardViewModel(
                id: "3",
                title: "Functions",
                description: "Reusable code",
                order: 3,
                state: .completed,
                actionTitle: "Continue"
            )
        ) {}
    }
    .padding()
}
