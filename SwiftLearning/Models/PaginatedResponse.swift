import Foundation

struct PaginatedResponse<Item: Decodable>: Decodable {
    let items: [Item]
    let total: Int
    let limit: Int
    let offset: Int
    let hasMore: Bool
}
