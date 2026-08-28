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
            .padding(AppSpacing.screen)
        }
        .background(AppColors.screenBackground)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationLink(value: ProfileRouter.Route.settings) {
                    Image(systemName: "gearshape")
                }
                .accessibilityLabel(L10n.string("profile.settings"))
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button(L10n.string("profile.logout")) {
                    viewModel.logout()
                }
            }
        }
        .task {
            await viewModel.loadProfile()
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
            Text(L10n.string("profile.yourProgress"))
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
            .appCard(
                radius: AppRadius.largeCard,
                padding: AppSpacing.section
            )
        }
    }

    private var courseCompletedCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.title3)
                .foregroundStyle(.green)

            VStack(alignment: .leading, spacing: 3) {
                Text(L10n.string("profile.courseCompleted.title"))
                    .font(.headline)
                    .foregroundStyle(.green)

                Text(L10n.string("profile.courseCompleted.message"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.large)
        .appRoundedBackground(
            Color.green.opacity(AppOpacity.tintFill),
            radius: AppRadius.card
        )
    }

    private func statisticsSection(statistics: [StatCardViewModel]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(L10n.string("profile.statistics"))
                .font(.title2)
                .fontWeight(.bold)

            LazyVGrid(columns: statisticColumns, spacing: 12) {
                ForEach(statistics) { statistic in
                    StatCardView(viewModel: statistic)
                }
            }
        }
    }

    private func achievementsSection(achievements: [AchievementCardViewModel]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(L10n.string("profile.achievements"))
                .font(.title2)
                .fontWeight(.bold)

            VStack(spacing: 12) {
                ForEach(achievements) { achievement in
                    AchievementCardView(viewModel: achievement)
                }
            }
        }
    }

    private var loadingView: some View {
        LoadingStateView(title: L10n.string("profile.loading"))
    }

    private func errorView(message: String) -> some View {
        ErrorStateView(
            title: L10n.string("profile.error.load"),
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
