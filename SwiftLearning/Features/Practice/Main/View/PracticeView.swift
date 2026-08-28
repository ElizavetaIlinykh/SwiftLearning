import SwiftUI

struct PracticeView: View {
    // MARK: - Private properties -

    @StateObject private var viewModel: PracticeViewModel

    // MARK: - Init -

    init(viewModel: PracticeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Public properties -

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                infoCard
                content
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(L10n.string("practice.navigationTitle"))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadTopics()
        }
        .refreshable {
            await viewModel.refreshTopics()
        }
        .onScrollTargetVisibilityChange(
            idType: String.self,
            threshold: 0.3
        ) { visibleIDs in
            loadMoreIfNeeded(visibleTopicIDs: visibleIDs)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case let .error(message):
            errorView(message: message)
        case .empty:
            emptyView
        case let .content(contentViewModel):
            topicsList(contentViewModel)
        }
    }

    private func topicsList(_ contentViewModel: PracticeContentViewModel) -> some View {
        VStack(spacing: 14) {
            LazyVStack(spacing: 14) {
                ForEach(contentViewModel.topics) { topic in
                    PracticeCategoryCardView(viewModel: topic) {
                        viewModel.selectTopic(id: topic.id)
                    }
                }
            }
            .scrollTargetLayout()

            LoadMoreView(state: contentViewModel.loadMoreState) {
                await viewModel.retryLoadMoreTopics()
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "chevron.left.forwardslash.chevron.right")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(Color.accentColor)
                .frame(width: 58, height: 58)
                .background(Color.accentColor.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 6) {
                Text(L10n.string("practice.header.title"))
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(L10n.string("practice.header.subtitle"))
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.string("practice.info.title"))
                .font(.headline)

            Text(L10n.string("practice.info.message"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }

    private var loadingView: some View {
        LoadingStateView(title: L10n.string("practice.loadingTopics"))
    }

    // MARK: - Private methods -

    private func loadMoreIfNeeded(visibleTopicIDs: [String]) {
        let preloadIDs = viewModel.topicCards
            .suffix(5)
            .map(\.id)

        guard let currentTopicID = preloadIDs.first(where: visibleTopicIDs.contains) else {
            return
        }

        Task {
            await viewModel.loadMoreTopicsIfNeeded(currentTopicID: currentTopicID)
        }
    }

    private func errorView(message: String) -> some View {
        ErrorStateView(
            title: L10n.string("practice.error.loadTopics"),
            message: message
        ) {
            Task {
                await viewModel.loadTopics()
            }
        }
    }

    private var emptyView: some View {
        EmptyStateView(
            title: L10n.string("practice.empty.title"),
            message: L10n.string("practice.empty.message")
        )
    }
}

#Preview {
    NavigationStack {
        PracticeModuleAssembler.assemble(
            dependencies: AppDependenciesAssembler.assemble(),
            output: { _ in }
        )
    }
}
