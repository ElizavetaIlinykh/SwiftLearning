import Foundation

// MARK: - Public methods -

func paginationQueryItems(offset: Int, limit: Int) -> [URLQueryItem] {
    [
        URLQueryItem(name: "offset", value: String(offset)),
        URLQueryItem(name: "limit", value: String(limit))
    ]
}
