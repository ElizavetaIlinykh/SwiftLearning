import SwiftUI

struct LessonCompletedView: View {
    let lesson: Lesson
    let didEarnXP: Bool
    let onContinue: () -> Void

    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 88, weight: .semibold))
                .foregroundStyle(.green)
                .scaleEffect(isVisible ? 1.0 : 0.7)
                .opacity(isVisible ? 1 : 0)
                .animation(.spring(response: 0.45, dampingFraction: 0.72), value: isVisible)

            VStack(spacing: 10) {
                Text("Lesson Complete!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("You completed \(lesson.title)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Text(didEarnXP ? "+20 XP" : "Lesson reviewed")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(didEarnXP ? .green : .secondary)
                .padding(.horizontal, 22)
                .padding(.vertical, 12)
                .background((didEarnXP ? Color.green : Color.secondary).opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Spacer()

            PrimaryButton(title: "Continue", action: onContinue)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            isVisible = true
        }
    }
}

#Preview {
    LessonCompletedView(lesson: LessonData.lessons[0], didEarnXP: true) {}
}
