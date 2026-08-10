import SwiftUI

struct LearnView: View {
    @Environment(AppRouter.self) private var router
    @StateObject private var viewModel: LearnViewModel

    init(viewModel: LearnViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                header

                content
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadLessons()
        }
        .refreshable {
            await viewModel.loadLessons()
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

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingView
        case .failed(let message):
            errorView(message: message)
        case .loaded(let lessons):
            if lessons.isEmpty {
                emptyView
            } else {
                lessonsContent
            }
        }
    }

    private var lessonsContent: some View {
        Group {
            ProgressCard(
                courseTitle: "Swift Basics",
                completedLessonsCount: viewModel.completedLessonsCount,
                totalLessonsCount: viewModel.lessons.count
            ) {}

            VStack(alignment: .leading, spacing: 14) {
                Text("Course")
                    .font(.title2)
                    .fontWeight(.bold)

                ForEach(viewModel.lessonCards) { lessonCard in
                    LessonCard(viewModel: lessonCard) {
                        router.push(
                            .lesson(
                                id: lessonCard.id,
                                totalLessonsCount: viewModel.lessons.count
                            )
                        )
                    }
                }
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: 14) {
            ProgressView()
            Text("Loading lessons")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }

    private func errorView(message: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Could not load lessons")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            PrimaryButton(title: "Try Again") {
                Task {
                    await viewModel.loadLessons()
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

    private var emptyView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("No lessons yet")
                .font(.headline)

            Text("Lessons will appear here when the server returns them.")
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
    LearnModuleAssembler.assemble(dependencies: AppDependenciesAssembler.assemble())
        .environment(AppRouter())
}
