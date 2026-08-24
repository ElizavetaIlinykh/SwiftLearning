import SwiftUI

struct ProfileView: View {
    // MARK: - Private properties -

    @StateObject private var viewModel: ProfileViewModel

    private let statisticColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    // MARK: - Init -

    init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Public properties -

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
        case .loading:
            loadingView
        case let .error(message):
            errorView(message: message)
        case let .content(contentViewModel):
            profileHeader(viewModel: contentViewModel.header)
            progressSection(viewModel: contentViewModel.progress)
            statisticsSection(statistics: contentViewModel.statistics)
            achievementsSection(achievements: contentViewModel.achievements)
        }
    }

    // MARK: - Private methods -

    private func profileHeader(viewModel: ProfileHeaderViewModel) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 92, weight: .regular))
                .foregroundStyle(Color.accentColor)

            VStack(spacing: 5) {
                Text(viewModel.name)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(viewModel.email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    private func progressSection(viewModel: ProfileProgressViewModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(.title2)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline) {
                    Text(viewModel.title)
                        .font(.headline)

                    Spacer()

                    Text(viewModel.percentTitle)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentColor)
                }

                ProgressView(value: viewModel.progress)
                    .tint(.accentColor)

                if viewModel.isCourseCompleted {
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

    private func statisticsSection(statistics: [StatCardViewModel]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Statistics")
                .font(.title2)
                .fontWeight(.bold)

            LazyVGrid(columns: statisticColumns, spacing: 12) {
                ForEach(statistics) { statistic in
                    StatCard(viewModel: statistic)
                }
            }
        }
    }

    private func achievementsSection(achievements: [AchievementCardViewModel]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Achievements")
                .font(.title2)
                .fontWeight(.bold)

            VStack(spacing: 12) {
                ForEach(achievements) { achievement in
                    AchievementCard(viewModel: achievement)
                }
            }
        }
    }

    private var loadingView: some View {
        LoadingStateView(title: "Loading profile")
    }

    private func errorView(message: String) -> some View {
        ErrorStateView(
            title: "Could not load profile",
            message: message
        ) {
            Task {
                await viewModel.loadProfile()
            }
        }
    }
}

#Preview {
    ProfileModuleAssembler.assemble(dependencies: AppDependenciesAssembler.assemble())
}
