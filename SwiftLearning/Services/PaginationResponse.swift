import Foundation

public struct PaginationResponse<T: INetworkEntity>: Sendable {
    public let result: [T]
    public let hasNext: Bool
}
