import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel

    private let statisticColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                content
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Logout") {
                viewModel.logout()
            }
        }
        .onAppear {
            Task {
                await viewModel.loadProfile()
            }
        }
        .refreshable {
            await viewModel.loadProfile()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingView
        case .failed(let message):
            errorView(message: message)
        case .loaded(let user, let statistics):
            profileHeader(user: user)
            progressSection(statistics: statistics)
            statisticsSection(statistics: statistics)
            achievementsSection(statistics: statistics)
        }
    }

    private func profileHeader(user: UserProfile) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 92, weight: .regular))
                .foregroundStyle(Color.accentColor)

            VStack(spacing: 5) {
                Text(user.name)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(user.email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    private func progressSection(statistics: UserStatistics) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(.title2)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(statistics.completedLessonsCount) of \(statistics.totalLessonsCount) lessons completed")
                        .font(.headline)

                    Spacer()

                    Text("\(statistics.progressPercent)%")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentColor)
                }

                ProgressView(value: progressValue(for: statistics))
                    .tint(.accentColor)

                if isCourseCompleted(statistics) {
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

    private func statisticsSection(statistics: UserStatistics) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Statistics")
                .font(.title2)
                .fontWeight(.bold)

            LazyVGrid(columns: statisticColumns, spacing: 12) {
                StatCard(title: "Level", value: "\(statistics.currentLevel)", systemImage: "bolt.fill")
                StatCard(title: "Lessons", value: "\(statistics.completedLessonsCount) / \(statistics.totalLessonsCount)", systemImage: "book.fill")
                StatCard(title: "Progress", value: "\(statistics.progressPercent)%", systemImage: "target")
            }
        }
    }

    private func achievementsSection(statistics: UserStatistics) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Achievements")
                .font(.title2)
                .fontWeight(.bold)

            VStack(spacing: 12) {
                ForEach(achievements(for: statistics)) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: 14) {
            ProgressView()
            Text("Loading profile")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }

    private func errorView(message: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Could not load profile")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            PrimaryButton(title: "Try Again") {
                Task {
                    await viewModel.loadProfile()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }

    private func achievements(for statistics: UserStatistics) -> [Achievement] {
        let completedCount = statistics.completedLessonsCount

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
                isUnlocked: isCourseCompleted(statistics)
            )
        ]
    }

    private func progressValue(for statistics: UserStatistics) -> Double {
        Double(statistics.progressPercent) / 100
    }

    private func isCourseCompleted(_ statistics: UserStatistics) -> Bool {
        statistics.totalLessonsCount > 0 && statistics.completedLessonsCount == statistics.totalLessonsCount
    }
}

#Preview {
    ProfileModuleAssembler.assemble(dependencies: AppDependenciesAssembler.assemble())
}
