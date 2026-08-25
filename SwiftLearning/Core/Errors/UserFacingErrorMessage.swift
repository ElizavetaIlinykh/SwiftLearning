import Foundation

enum UserFacingErrorMessage {
    // MARK: - Public methods -

    static func message(
        for error: Error,
        fallback: String = "Something went wrong. Please try again."
    ) -> String {
        if let authError = error as? AuthError {
            return authError.localizedDescription
        }

        if let networkError = error as? NetworkManager.NetworkError {
            return message(for: networkError)
        }

        if let urlError = error as? URLError {
            return message(for: urlError)
        }

        return fallback
    }

    // MARK: - Private methods -

    private static func message(for error: NetworkManager.NetworkError) -> String {
        switch error {
        case .invalidURL:
            "We could not prepare this request. Please try again."
        case .invalidResponse:
            "The server returned an unexpected response. Please try again."
        case let .serverError(statusCode, _):
            message(forStatusCode: statusCode)
        case .decodingFailed:
            "We could not read the server response. Please try again later."
        }
    }

    private static func message(forStatusCode statusCode: Int) -> String {
        switch statusCode {
        case 401:
            "Please sign in to continue."
        case 403:
            "You do not have permission to perform this action."
        case 404:
            "We could not find this content."
        case 409:
            "This action conflicts with the current state. Please refresh and try again."
        case 422:
            "Some information looks invalid. Please check it and try again."
        case 500 ... 599:
            "The server is unavailable right now. Please try again later."
        default:
            "Request failed. Please try again."
        }
    }

    private static func message(for error: URLError) -> String {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            "Check your internet connection and try again."
        case .timedOut:
            "The request timed out. Please try again."
        default:
            "Network request failed. Please try again."
        }
    }
}
