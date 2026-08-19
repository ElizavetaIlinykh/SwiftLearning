import Foundation

struct PracticeCategory: Identifiable, Hashable, INetworkEntity {
    // MARK: - Public properties -

    let id: String
    let title: String
    let description: String
    let order: Int
    let tasksCount: Int

    var systemImage: String {
        "chevron.left.forwardslash.chevron.right"
    }
}
