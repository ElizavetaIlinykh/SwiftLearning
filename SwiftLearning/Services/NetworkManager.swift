import Foundation

protocol NetworkManaging {
    func get<Response: Decodable>(
        _ path: String,
        queryItems: [URLQueryItem]
    ) async throws -> Response

    func post<Body: Encodable, Response: Decodable>(
        _ path: String,
        body: Body,
        queryItems: [URLQueryItem]
    ) async throws -> Response

    func put<Body: Encodable, Response: Decodable>(
        _ path: String,
        body: Body
    ) async throws -> Response

    func delete<Response: Decodable>(_ path: String) async throws -> Response
}

extension NetworkManaging {
    func get<Response: Decodable>(_ path: String) async throws -> Response {
        try await get(path, queryItems: [])
    }

    func post<Body: Encodable, Response: Decodable>(
        _ path: String,
        body: Body
    ) async throws -> Response {
        try await post(path, body: body, queryItems: [])
    }
}

final class NetworkManager: NetworkManaging {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let tokenStorage: TokenStoring?

    var unauthorizedHandler: (() -> Void)?

    init(
        baseURL: URL = URL(string: "http://127.0.0.1:8000")!,
        session: URLSession = .shared,
        tokenStorage: TokenStoring? = nil
    ) {
        self.baseURL = baseURL
        self.session = session
        self.tokenStorage = tokenStorage

        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            if let date = ISO8601DateFormatter.backendDateFormatter.date(from: dateString) {
                return date
            }

            if let date = ISO8601DateFormatter.backendDateFormatterWithFractionalSeconds.date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid ISO-8601 date: \(dateString)"
            )
        }

        self.encoder = JSONEncoder()
        self.encoder.keyEncodingStrategy = .convertToSnakeCase
        self.encoder.dateEncodingStrategy = .iso8601
    }

    func get<Response: Decodable>(
        _ path: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> Response {
        let request = try makeRequest(path: path, method: .get, queryItems: queryItems)
        return try await send(request)
    }

    func post<Body: Encodable, Response: Decodable>(
        _ path: String,
        body: Body,
        queryItems: [URLQueryItem] = []
    ) async throws -> Response {
        var request = try makeRequest(path: path, method: .post, queryItems: queryItems)
        request.httpBody = try encoder.encode(body)
        return try await send(request)
    }

    func put<Body: Encodable, Response: Decodable>(
        _ path: String,
        body: Body
    ) async throws -> Response {
        var request = try makeRequest(path: path, method: .put)
        request.httpBody = try encoder.encode(body)
        return try await send(request)
    }

    func delete<Response: Decodable>(_ path: String) async throws -> Response {
        let request = try makeRequest(path: path, method: .delete)
        return try await send(request)
    }

    private func send<Response: Decodable>(_ request: URLRequest) async throws -> Response {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401, !isAuthEndpoint(request) {
                unauthorizedHandler?()
            }
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
        }

        if Response.self == EmptyResponse.self, data.isEmpty {
            return EmptyResponse() as! Response
        }

        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }

    private func makeRequest(
        path: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem] = []
    ) throws -> URLRequest {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))),
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidURL
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if !isAuthEndpoint(path), let accessToken = try tokenStorage?.fetchAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    private func isAuthEndpoint(_ request: URLRequest) -> Bool {
        guard let path = request.url?.path else { return false }
        return isAuthEndpoint(path)
    }

    private func isAuthEndpoint(_ path: String) -> Bool {
        let normalizedPath = path.hasPrefix("/") ? path : "/\(path)"
        return normalizedPath == "/auth/register" || normalizedPath == "/auth/login"
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
                return "Invalid URL."
            case .invalidResponse:
                return "Invalid server response."
            case .serverError(let statusCode, _):
                return "Server returned status code \(statusCode)."
            case .decodingFailed(let error):
                return "Failed to decode response: \(error.localizedDescription)"
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

    static let backendDateFormatterWithFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
