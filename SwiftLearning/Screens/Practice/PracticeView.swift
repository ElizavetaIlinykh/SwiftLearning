import SwiftUI

struct PracticeView: View {
    @State private var navigationPath: [PracticeCategory] = []

    private let categories = PracticeData.categories

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    infoCard

                    VStack(spacing: 14) {
                        ForEach(categories) { category in
                            PracticeCategoryCard(category: category) {
                                navigationPath.append(category)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Practice")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PracticeCategory.self) { category in
                PracticeSessionView(category: category) {
                    navigationPath.removeAll()
                }
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

            Text("Answer 5 questions and check your Swift knowledge.")
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
}

#Preview {
    PracticeView()
}
