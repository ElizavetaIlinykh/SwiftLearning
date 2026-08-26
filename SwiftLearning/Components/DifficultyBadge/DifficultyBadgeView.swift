import SwiftUI

struct DifficultyBadgeView: View {
    // MARK: - Public properties -

    let difficulty: Difficulty

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .clipShape(Capsule())
            .accessibilityLabel("Difficulty: \(title)")
    }

    // MARK: - Private properties -

    private var title: String {
        switch difficulty {
        case .easy:
            "Easy"
        case .medium:
            "Medium"
        case .hard:
            "Hard"
        case .unknown:
            "Unknown"
        }
    }

    private var foregroundColor: Color {
        switch difficulty {
        case .easy:
            .green
        case .medium:
            .orange
        case .hard:
            .red
        case .unknown:
            .secondary
        }
    }

    private var backgroundColor: Color {
        foregroundColor.opacity(0.13)
    }
}

#Preview {
    HStack {
        DifficultyBadgeView(difficulty: .easy)
        DifficultyBadgeView(difficulty: .medium)
        DifficultyBadgeView(difficulty: .hard)
        DifficultyBadgeView(difficulty: .unknown)
    }
    .padding()
}
