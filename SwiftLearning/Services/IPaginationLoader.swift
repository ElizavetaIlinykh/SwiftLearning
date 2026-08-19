import Foundation

public protocol IPaginationLoader: Sendable {
    associatedtype Value: INetworkEntity

    var contract: PaginationLoaderContract { get set }

    func fetch() async throws -> PaginationResponse<Value>
    func loadNext() async throws -> PaginationResponse<Value>
}
