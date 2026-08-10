import SwiftUI

struct LessonQuizRouteView: View {
    @Environment(AppRouter.self) private var router

    let lessonID: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Quick Check")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Review the theory before moving to the code task.")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Quiz")
                        .font(.headline)

                    Text("Quiz content will be loaded here when the backend returns questions for this lesson.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(5)
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                PrimaryButton(title: "Continue") {
                    router.push(.codeTask(lessonID: lessonID))
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LessonQuizRouteView(lessonID: "57451d1d-27d4-40a3-86a1-3c06b176be68")
            .environment(AppRouter())
    }
}
