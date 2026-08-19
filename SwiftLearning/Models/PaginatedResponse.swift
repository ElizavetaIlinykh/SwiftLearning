import Foundation

nonisolated struct PaginatedResponse<Item: Decodable & Equatable>: Decodable, Equatable {
    let items: [Item]
    let total: Int
    let limit: Int
    let offset: Int
    let hasMore: Bool
}
