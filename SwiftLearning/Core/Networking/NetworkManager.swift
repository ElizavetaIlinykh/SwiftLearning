import Foundation

protocol NetworkManaging {
    func get<Response: Decodable>(_ endpoint: APIEndpoint) async throws -> Response

    func post<Response: Decodable>(
        _ endpoint: APIEndpoint,
        body: some Encodable
    ) async throws -> Response

    func put<Response: Decodable>(
        _ endpoint: APIEndpoint,
        body: some Encodable
    ) async throws -> Response

    func delete<Response: Decodable>(_ endpoint: APIEndpoint) async throws -> Response
}

final class NetworkManager: NetworkManaging {
    // MARK: - Private properties -

    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let tokenStorage: TokenStoring?

    // MARK: - Public properties -

    var unauthorizedHandler: (() -> Void)?

    // MARK: - Init -

    init(
        baseURL: URL,
        session: URLSession = .shared,
        tokenStorage: TokenStoring? = nil
    ) {
        self.baseURL = baseURL
        self.session = session
        self.tokenStorage = tokenStorage

        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            if let date = ISO8601DateFormatter.backendDateFormatter.date(from: dateString) {
                return date
            }

            if let date = ISO8601DateFormatter.backendFractionalDateFormatter.date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid ISO-8601 date: \(dateString)"
            )
        }

        encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
    }

    // MARK: - Public methods -

    func get<Response: Decodable>(_ endpoint: APIEndpoint) async throws -> Response {
        let request = try makeRequest(endpoint: endpoint, method: .get)
        return try await send(request, endpoint: endpoint)
    }

    func post<Response: Decodable>(
        _ endpoint: APIEndpoint,
        body: some Encodable
    ) async throws -> Response {
        var request = try makeRequest(endpoint: endpoint, method: .post)
        request.httpBody = try encoder.encode(body)
        return try await send(request, endpoint: endpoint)
    }

    func put<Response: Decodable>(
        _ endpoint: APIEndpoint,
        body: some Encodable
    ) async throws -> Response {
        var request = try makeRequest(endpoint: endpoint, method: .put)
        request.httpBody = try encoder.encode(body)
        return try await send(request, endpoint: endpoint)
    }

    func delete<Response: Decodable>(_ endpoint: APIEndpoint) async throws -> Response {
        let request = try makeRequest(endpoint: endpoint, method: .delete)
        return try await send(request, endpoint: endpoint)
    }

    // MARK: - Private methods -

    private func send<Response: Decodable>(
        _ request: URLRequest,
        endpoint: APIEndpoint
    ) async throws -> Response {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200 ... 299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401, endpoint.requiresAuthorization {
                unauthorizedHandler?()
            }
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
        }

        if data.isEmpty, let emptyResponse = EmptyResponse() as? Response {
            return emptyResponse
        }

        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }

    private func makeRequest(
        endpoint: APIEndpoint,
        method: HTTPMethod
    ) throws -> URLRequest {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(endpoint.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))),
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidURL
        }

        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if endpoint.requiresAuthorization, let accessToken = try tokenStorage?.fetchAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}

extension NetworkManager {
    struct EmptyResponse: Decodable {
        init() {}
    }

    enum NetworkError: LocalizedError {
        case invalidURL
        case invalidResponse
        case serverError(statusCode: Int, data: Data)
        case decodingFailed(Error)

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                "Invalid URL."
            case .invalidResponse:
                "Invalid server response."
            case let .serverError(statusCode, _):
                "Server returned status code \(statusCode)."
            case let .decodingFailed(error):
                "Failed to decode response: \(error.localizedDescription)"
            }
        }
    }
}

private enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

private extension ISO8601DateFormatter {
    static let backendDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    static let backendFractionalDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
