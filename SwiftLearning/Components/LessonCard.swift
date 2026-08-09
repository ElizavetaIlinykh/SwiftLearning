import SwiftUI

enum LessonState {
    case completed
    case current
    case locked
}

struct LessonCard: View {
    let lesson: Lesson
    let state: LessonState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(String(format: "%02d", lesson.id))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(numberColor)
                    .frame(width: 44, height: 44)
                    .background(numberBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                VStack(alignment: .leading, spacing: 6) {
                    Text(lesson.title)
                        .font(.headline)
                        .foregroundStyle(titleColor)

                    Text(lesson.duration)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 12)

                stateView
            }
            .padding(16)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(borderColor, lineWidth: state == .current ? 1.5 : 1)
            )
            .opacity(state == .locked ? 0.62 : 1)
        }
        .buttonStyle(.plain)
        .disabled(state == .locked)
    }

    @ViewBuilder
    private var stateView: some View {
        switch state {
        case .completed:
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundStyle(.green)
        case .current:
            HStack(spacing: 6) {
                Text(lesson.id == 1 ? "Start" : "Continue")
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
        switch state {
        case .completed:
            return Color.green.opacity(0.08)
        case .current:
            return Color.accentColor.opacity(0.10)
        case .locked:
            return Color.secondary.opacity(0.08)
        }
    }

    private var borderColor: Color {
        switch state {
        case .completed:
            return Color.green.opacity(0.22)
        case .current:
            return Color.accentColor.opacity(0.55)
        case .locked:
            return Color.secondary.opacity(0.12)
        }
    }

    private var numberColor: Color {
        state == .locked ? .secondary : .accentColor
    }

    private var titleColor: Color {
        state == .locked ? .secondary : .primary
    }

    private var numberBackground: Color {
        state == .locked ? Color.secondary.opacity(0.10) : Color.accentColor.opacity(0.13)
    }
}

#Preview {
    VStack(spacing: 12) {
        LessonCard(lesson: LessonData.lessons[0], state: .current) {}
        LessonCard(lesson: LessonData.lessons[1], state: .locked) {}
        LessonCard(lesson: LessonData.lessons[2], state: .completed) {}
    }
    .padding()
}
