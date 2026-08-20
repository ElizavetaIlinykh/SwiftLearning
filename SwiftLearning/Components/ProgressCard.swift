import SwiftUI

enum ProgressCardState {
    case notStarted
    case inProgress
    case completed
}

struct ProgressCardViewModel: Equatable {
    // MARK: - Public properties -

    let courseTitle: String
    let completedLessonsCount: Int
    let totalLessonsCount: Int
    let progress: Double
    let state: ProgressCardState
}

struct ProgressCard: View {
    // MARK: - Public properties -

    let viewModel: ProgressCardViewModel
    let action: (() -> Void)?

    // MARK: - Init -

    init(
        viewModel: ProgressCardViewModel,
        action: (() -> Void)? = nil
    ) {
        self.viewModel = viewModel
        self.action = action
    }

    // MARK: - Public properties -

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.courseTitle)
                    .font(.title3)
                    .fontWeight(.bold)

                Text("\(viewModel.completedLessonsCount) of \(viewModel.totalLessonsCount) lessons completed")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: viewModel.progress)
                .tint(.accentColor)

            footer
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }

    // MARK: - Private properties -

    @ViewBuilder
    private var footer: some View {
        switch viewModel.state {
        case .completed:
            HStack(spacing: 10) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)

                Text("Course Completed")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color.green.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

        case .notStarted:
            if let action {
                PrimaryButton(title: "Start Learning", action: action)
            }

        case .inProgress:
            if let action {
                PrimaryButton(title: "Continue Learning", action: action)
            }
        }
    }
}

#Preview {
    ProgressCard(
        viewModel: ProgressCardViewModel(
            courseTitle: "Swift Basics",
            completedLessonsCount: 0,
            totalLessonsCount: 8,
            progress: 0,
            state: .notStarted
        )
    ) {}
        .padding()
        .background(Color(.systemGroupedBackground))
}
