import Foundation
import Security

protocol TokenStoring {
    func fetchAccessToken() throws -> String?
    func saveAccessToken(_ token: String) throws
    func deleteAccessToken() throws
}

final class KeychainTokenStorage: TokenStoring {
    private let service: String
    private let account: String

    init(
        service: String = Bundle.main.bundleIdentifier ?? "SwiftLearning",
        account: String = "accessToken"
    ) {
        self.service = service
        self.account = account
    }

    func fetchAccessToken() throws -> String? {
        var query = baseQuery()
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess else {
            throw TokenStorageError.keychainStatus(status)
        }

        guard
            let data = item as? Data,
            let token = String(data: data, encoding: .utf8)
        else {
            throw TokenStorageError.invalidStoredToken
        }

        return token
    }

    func saveAccessToken(_ token: String) throws {
        let tokenData = Data(token.utf8)
        var query = baseQuery()
        query[kSecValueData as String] = tokenData
        query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly

        let status = SecItemAdd(query as CFDictionary, nil)

        if status == errSecDuplicateItem {
            let attributes = [kSecValueData as String: tokenData]
            let updateStatus = SecItemUpdate(baseQuery() as CFDictionary, attributes as CFDictionary)

            guard updateStatus == errSecSuccess else {
                throw TokenStorageError.keychainStatus(updateStatus)
            }
            return
        }

        guard status == errSecSuccess else {
            throw TokenStorageError.keychainStatus(status)
        }
    }

    func deleteAccessToken() throws {
        let status = SecItemDelete(baseQuery() as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw TokenStorageError.keychainStatus(status)
        }
    }

    private func baseQuery() -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
    }
}

enum TokenStorageError: LocalizedError {
    case invalidStoredToken
    case keychainStatus(OSStatus)

    var errorDescription: String? {
        switch self {
        case .invalidStoredToken:
            "Stored access token is invalid."
        case let .keychainStatus(status):
            "Keychain operation failed with status \(status)."
        }
    }
}
