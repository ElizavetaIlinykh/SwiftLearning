import Foundation

@MainActor
public protocol IPaginationLoader: Sendable {
    // MARK: - Associated types -

    associatedtype Value: INetworkEntity & Sendable

    // MARK: - Public properties -

    var contract: PaginationLoaderContract { get set }

    // MARK: - Public methods -

    func fetch() async throws -> PaginationResponse<Value>
    func loadNext() async throws -> PaginationResponse<Value>
}
