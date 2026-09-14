import Foundation

enum AppEnvironment: String {
    case development
    case production

    static var defaultEnvironment: AppEnvironment {
        #if DEBUG
            .development
        #else
            .production
        #endif
    }
}

struct AppConfiguration {
    // MARK: - Private types -

    private enum Constants {
        static let environmentKey = "APP_ENVIRONMENT"
        static let baseURLOverrideKey = "API_BASE_URL"
        static let defaultBaseURL = "https://swift-learning-backend.onrender.com"
    }

    // MARK: - Public properties -

    let environment: AppEnvironment
    let baseURL: URL

    // MARK: - Public methods -

    static func load(
        bundle: Bundle = .main,
        environment processEnvironment: [String: String] = ProcessInfo.processInfo.environment
    ) -> AppConfiguration {
        let appEnvironment = resolveEnvironment(
            bundle: bundle,
            processEnvironment: processEnvironment
        )
        let baseURLString = configurationValue(
            forKey: Constants.baseURLOverrideKey,
            bundle: bundle,
            processEnvironment: processEnvironment
        ) ?? Constants.defaultBaseURL

        return AppConfiguration(
            environment: appEnvironment,
            baseURL: validatedBaseURL(baseURLString, environment: appEnvironment)
        )
    }

    // MARK: - Private methods -

    private static func resolveEnvironment(
        bundle: Bundle,
        processEnvironment: [String: String]
    ) -> AppEnvironment {
        guard let environmentValue = configurationValue(
            forKey: Constants.environmentKey,
            bundle: bundle,
            processEnvironment: processEnvironment
        ) else {
            return AppEnvironment.defaultEnvironment
        }

        guard let appEnvironment = AppEnvironment(rawValue: environmentValue) else {
            configurationFailure("Invalid app environment: \(environmentValue). Expected development or production.")
        }

        return appEnvironment
    }

    private static func configurationValue(
        forKey key: String,
        bundle: Bundle,
        processEnvironment: [String: String]
    ) -> String? {
        let value = processEnvironment[key]
            ?? bundle.object(forInfoDictionaryKey: key) as? String

        let trimmedValue = value?.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedValue?.isEmpty == false ? trimmedValue : nil
    }

    private static func validatedBaseURL(
        _ value: String,
        environment: AppEnvironment
    ) -> URL {
        guard !value.contains("REPLACE_WITH"),
              !value.contains("<"),
              !value.contains(">")
        else {
            configurationFailure("Replace \(Constants.baseURLOverrideKey) with the public backend URL before using \(environment.rawValue).")
        }

        guard let url = URL(string: value),
              let scheme = url.scheme,
              let host = url.host,
              !host.isEmpty,
              ["http", "https"].contains(scheme)
        else {
            configurationFailure("Invalid API base URL for \(environment.rawValue): \(value). Use an absolute http or https URL.")
        }

        if environment == .production, scheme != "https" {
            configurationFailure("Production API base URL must use HTTPS: \(value).")
        }

        return url
    }

    private static func configurationFailure(_ message: String) -> Never {
        preconditionFailure("AppConfiguration error: \(message)")
    }
}
