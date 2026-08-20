import SwiftUI

struct PracticeView: View {
    // MARK: - Private properties -

    // MARK: - Init -

    @Environment(AppRouter.self) private var router
    @StateObject private var viewModel: PracticeViewModel
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
        .navigationTitle("Practice")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.loadTopics()
            }
        }
        .refreshable {
            await viewModel.refreshTopics()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingView
        case let .failed(message):
            errorView(message: message)
        case let .loaded(topics, _):
            if topics.isEmpty {
                emptyView
            } else {
                topicsList
            }
        }
    }

    private var topicsList: some View {
        VStack(spacing: 14) {
            ForEach(viewModel.topics) { topic in
                PracticeCategoryCard(category: topic) {
                    router.push(.exercise(id: topic.id, title: topic.title, attemptID: UUID()))
                }
                .onAppear {
                    Task {
                        await viewModel.loadMoreTopicsIfNeeded(currentTopicID: topic.id)
                    }
                }
            }

            LoadMoreView(state: viewModel.loadMoreState) {
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
                Text("Practice Swift")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Improve your skills with quick challenges")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Quick Practice")
                .font(.headline)

            Text("Answer questions and check your Swift knowledge.")
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
        VStack(spacing: 14) {
            ProgressView()
            Text("Loading practice topics")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }

    // MARK: - Private methods -

    private func errorView(message: String) -> some View {
        ErrorStateView(
            title: "Could not load practice topics",
            message: message
        ) {
            Task {
                await viewModel.loadTopics()
            }
        }
    }

    private var emptyView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("No practice topics yet")
                .font(.headline)

            Text("Topics will appear here when the server returns them.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
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
}

#Preview {
    NavigationStack {
        PracticeModuleAssembler.assemble(dependencies: AppDependenciesAssembler.assemble())
            .environment(AppRouter())
    }
}
