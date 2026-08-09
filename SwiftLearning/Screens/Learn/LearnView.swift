import SwiftUI

struct LearnView: View {
    @EnvironmentObject private var progressStore: LearningProgressStore
    @State private var navigationPath: [Lesson] = []

    private let lessons = LessonData.lessons

    private var completedLessonsCount: Int {
        lessons.filter { progressStore.isCompleted($0) }.count
    }

    private var currentLesson: Lesson? {
        lessons.first { lesson in
            !progressStore.isCompleted(lesson) && progressStore.isUnlocked(lesson)
        }
    }

    private var nextLesson: Lesson? {
        currentLesson
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    header

                    ProgressCard(
                        courseTitle: "Swift Basics",
                        completedLessonsCount: completedLessonsCount,
                        totalLessonsCount: lessons.count
                    ) {
                        openNextLesson()
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Course")
                            .font(.title2)
                            .fontWeight(.bold)

                        ForEach(lessons) { lesson in
                            LessonCard(
                                lesson: lesson,
                                state: state(for: lesson)
                            ) {
                                openLessonIfAvailable(lesson)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Lesson.self) { lesson in
                destination(for: lesson)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Swift Learning")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Continue learning Swift")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    private func destination(for lesson: Lesson) -> some View {
        LessonView(
            lesson: lesson,
            totalLessonsCount: lessons.count,
            wasAlreadyCompleted: progressStore.isCompleted(lesson)
        ) {
            navigationPath.removeAll()
        }
    }

    private func state(for lesson: Lesson) -> LessonState {
        if progressStore.isCompleted(lesson) {
            return .completed
        }

        if lesson == currentLesson {
            return .current
        }

        return .locked
    }

    private func openNextLesson() {
        guard let nextLesson else { return }
        navigationPath.append(nextLesson)
    }

    private func openLessonIfAvailable(_ lesson: Lesson) {
        guard state(for: lesson) != .locked else { return }
        navigationPath.append(lesson)
    }
}

#Preview {
    LearnView()
        .environmentObject(LearningProgressStore())
}
