import Foundation

public struct PaginationLoaderContract {
    public var initalOffset: Int
    public var limit: Int

    // MARK: - Init -

    public init(initalOffset: Int = 0, limit: Int = 20) {
        self.initalOffset = initalOffset
        self.limit = limit
    }
}
