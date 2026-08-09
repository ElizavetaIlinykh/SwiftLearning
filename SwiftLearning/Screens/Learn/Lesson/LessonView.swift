import SwiftUI

struct LessonView: View {
    let lesson: Lesson
    let totalLessonsCount: Int
    let wasAlreadyCompleted: Bool
    let onFlowCompleted: () -> Void

    private var courseProgress: Double {
        Double(lesson.id) / Double(totalLessonsCount)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                lessonProgress

                VStack(alignment: .leading, spacing: 12) {
                    Text("THEORY")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)

                    Text(lesson.theoryTitle)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(lesson.theoryText)
                        .font(.body)
                        .lineSpacing(6)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.primary)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("CODE EXAMPLE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)

                    CodeBlockView(code: lesson.codeExample)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("How it works")
                        .font(.headline)

                    Text(lesson.explanation)
                        .font(.body)
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.secondary)
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                NavigationLink {
                    QuizView(
                        lesson: lesson,
                        question: lesson.quiz,
                        wasAlreadyCompleted: wasAlreadyCompleted,
                        onFlowCompleted: onFlowCompleted
                    )
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(lesson.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var lessonProgress: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Lesson \(lesson.id) of \(totalLessonsCount)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Spacer()

                Text("\(lesson.id) / \(totalLessonsCount)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: courseProgress)
                .tint(.accentColor)
        }
    }
}

#Preview {
    NavigationStack {
        LessonView(
            lesson: LessonData.lessons[0],
            totalLessonsCount: LessonData.lessons.count,
            wasAlreadyCompleted: false
        ) {}
        .environmentObject(LearningProgressStore())
    }
}
