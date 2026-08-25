import Foundation

public struct PaginationResponse<T: INetworkEntity>: Sendable {
    // MARK: - Public properties -

    public let result: [T]
    public let hasNext: Bool

    // MARK: - Init -

    public init(result: [T], hasNext: Bool) {
        self.result = result
        self.hasNext = hasNext
    }
}
