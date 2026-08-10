import SwiftUI

struct LessonCompletionResultView: View {
    @Environment(AppRouter.self) private var router

    let lessonID: String

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

                Text("Your progress has been saved.")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Text("+20 XP")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.green)
                .padding(.horizontal, 22)
                .padding(.vertical, 12)
                .background(Color.green.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Spacer()

            PrimaryButton(title: "Continue") {
                router.popLessonsToRoot()
            }
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
    LessonCompletionResultView(lessonID: "57451d1d-27d4-40a3-86a1-3c06b176be68")
        .environment(AppRouter())
}
