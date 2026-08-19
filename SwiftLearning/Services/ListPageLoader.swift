import Foundation

public protocol INetworkEntity: Codable, Equatable {}

public struct PaginationLoaderContract {
  public var initalOffset: Int
  public var limit: Int
  public init(initalOffset: Int = 0, limit: Int = 20) {
    self.initalOffset = initalOffset
    self.limit = limit
  }
}

public protocol IPaginationLoader: Sendable {
  associatedtype Value: INetworkEntity
  var contract: PaginationLoaderContract { get set }
  func fetch() async throws -> PaginationResponse<Value>
  func loadNext() async throws -> PaginationResponse<Value>
}
public struct PaginationResponse<T: INetworkEntity>: Sendable {
  public let result: [T]
  public let hasNext: Bool
}

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
    self.offset = contract.initalOffset
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
    self.offset += result.count
    return .init(result: result, hasNext: result.count >= contract.limit)
  }
}
