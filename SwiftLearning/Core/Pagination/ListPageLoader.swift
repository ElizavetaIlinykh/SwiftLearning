import Foundation

@MainActor
public final class PaginationLoader<Value: INetworkEntity & Sendable>: IPaginationLoader {
    // MARK: - Private properties -

    private var offset: Int
    private let pageFetcher: (Int, Int) async throws -> PaginationResponse<Value>

    // MARK: - Public properties -

    public var contract: PaginationLoaderContract

    // MARK: - Init -

    public init(
        contract: PaginationLoaderContract,
        fetcher: @escaping (Int, Int) async throws -> [Value]
    ) {
        offset = contract.initalOffset
        self.contract = contract
        pageFetcher = { offset, limit in
            let result = try await fetcher(offset, limit)
            return PaginationResponse(
                result: result,
                hasNext: result.count >= limit
            )
        }
    }

    public init(
        contract: PaginationLoaderContract,
        pageFetcher: @escaping (Int, Int) async throws -> PaginationResponse<Value>
    ) {
        offset = contract.initalOffset
        self.contract = contract
        self.pageFetcher = pageFetcher
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
        let response = try await pageFetcher(offset, contract.limit)
        offset += response.result.count
        return response
    }
}
