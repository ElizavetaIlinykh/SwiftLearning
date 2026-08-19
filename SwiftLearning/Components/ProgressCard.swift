import SwiftUI

struct ProgressCard: View {
    let courseTitle: String
    let completedLessonsCount: Int
    let totalLessonsCount: Int
    let action: (() -> Void)?

    init(
        courseTitle: String,
        completedLessonsCount: Int,
        totalLessonsCount: Int,
        action: (() -> Void)? = nil
    ) {
        self.courseTitle = courseTitle
        self.completedLessonsCount = completedLessonsCount
        self.totalLessonsCount = totalLessonsCount
        self.action = action
    }

    private var progress: Double {
        guard totalLessonsCount > 0 else { return 0 }
        return Double(completedLessonsCount) / Double(totalLessonsCount)
    }

    private var isCourseCompleted: Bool {
        totalLessonsCount > 0 && completedLessonsCount == totalLessonsCount
    }

    private var buttonTitle: String {
        completedLessonsCount == 0 ? "Start Learning" : "Continue Learning"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text(courseTitle)
                    .font(.title3)
                    .fontWeight(.bold)

                Text("\(completedLessonsCount) of \(totalLessonsCount) lessons completed")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: progress)
                .tint(.accentColor)

            if isCourseCompleted {
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
            } else if let action {
                PrimaryButton(title: buttonTitle, action: action)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
}

#Preview {
    ProgressCard(
        courseTitle: "Swift Basics",
        completedLessonsCount: 0,
        totalLessonsCount: 8
    ) {}
        .padding()
        .background(Color(.systemGroupedBackground))
}
