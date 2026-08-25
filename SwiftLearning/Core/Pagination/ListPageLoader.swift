import Foundation

public final class PaginationLoader<Value: INetworkEntity & Sendable>: IPaginationLoader, @unchecked Sendable {
    // MARK: - Private properties -

    private var offset: Int
    private let fetcher: (Int, Int) async throws -> [Value]

    // MARK: - Public properties -

    public var contract: PaginationLoaderContract

    // MARK: - Init -

    public init(
        contract: PaginationLoaderContract = .init(),
        fetcher: @escaping (Int, Int) async throws -> [Value]
    ) {
        offset = contract.initalOffset
        self.contract = contract
        self.fetcher = fetcher
    }

    // MARK: - Public methods -

    public func fetch() async throws -> PaginationResponse<Value> {
        offset = contract.initalOffset
        return try await loadItems()
    }

    public func loadNext() async throws -> PaginationResponse<Value> {
        try await loadItems()
    }

    private func loadItems() async throws -> PaginationResponse<Value> {
        let result = try await fetcher(offset, contract.limit)
        offset += result.count
        return .init(result: result, hasNext: result.count >= contract.limit)
    }
}
