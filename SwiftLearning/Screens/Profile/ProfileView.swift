import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var progressStore: LearningProgressStore
    @State private var isShowingResetAlert = false

    private let totalLessonsCount = LessonData.lessons.count
    private let statisticColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private var achievements: [Achievement] {
        let completedCount = progressStore.completedLessonsCount

        return [
            Achievement(
                id: "first-step",
                title: "First Step",
                description: "Complete your first lesson",
                systemImage: "figure.walk",
                isUnlocked: completedCount >= 1
            ),
            Achievement(
                id: "swift-beginner",
                title: "Swift Beginner",
                description: "Complete 3 lessons",
                systemImage: "chevron.left.forwardslash.chevron.right",
                isUnlocked: completedCount >= 3
            ),
            Achievement(
                id: "halfway-there",
                title: "Halfway There",
                description: "Complete 4 lessons",
                systemImage: "flag.fill",
                isUnlocked: completedCount >= 4
            ),
            Achievement(
                id: "swift-explorer",
                title: "Swift Explorer",
                description: "Complete all lessons",
                systemImage: "trophy.fill",
                isUnlocked: completedCount == totalLessonsCount
            )
        ]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                profileHeader
                progressSection
                statisticsSection
                achievementsSection
                demoSection
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Reset progress?", isPresented: $isShowingResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                progressStore.resetProgress()
            }
        } message: {
            Text("All lesson progress, XP and quiz statistics will be removed.")
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 92, weight: .regular))
                .foregroundStyle(Color.accentColor)

            VStack(spacing: 5) {
                Text("Swift Learner")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Learning Swift one step at a time")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(.title2)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(progressStore.completedLessonsCount) of \(totalLessonsCount) lessons completed")
                        .font(.headline)

                    Spacer()

                    Text("\(progressStore.courseProgressPercentage)%")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentColor)
                }

                ProgressView(value: progressStore.courseProgress)
                    .tint(.accentColor)

                if progressStore.completedLessonsCount == totalLessonsCount {
                    courseCompletedCard
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

    private var courseCompletedCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.title3)
                .foregroundStyle(.green)

            VStack(alignment: .leading, spacing: 3) {
                Text("Course Completed")
                    .font(.headline)
                    .foregroundStyle(.green)

                Text("You finished Swift Basics!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.green.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Statistics")
                .font(.title2)
                .fontWeight(.bold)

            LazyVGrid(columns: statisticColumns, spacing: 12) {
                StatCard(title: "XP", value: "\(progressStore.xp)", systemImage: "bolt.fill")
                StatCard(title: "Lessons", value: "\(progressStore.completedLessonsCount) / \(totalLessonsCount)", systemImage: "book.fill")
                StatCard(title: "Accuracy", value: "\(progressStore.accuracy)%", systemImage: "target")
            }
        }
    }

    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Achievements")
                .font(.title2)
                .fontWeight(.bold)

            VStack(spacing: 12) {
                ForEach(achievements) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
        }
    }

    private var demoSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Demo")
                .font(.title2)
                .fontWeight(.bold)

            Button(role: .destructive) {
                isShowingResetAlert = true
            } label: {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reset Progress")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(LearningProgressStore())
}
