import Foundation
import Observation

@Observable
final class LanguageSettings {
    // MARK: - Private properties -

    private let storageKey = "app.selectedLanguage"

    // MARK: - Public properties -

    var selectedLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: storageKey)
            L10n.setLanguage(selectedLanguage)
        }
    }

    // MARK: - Init -

    init() {
        if let storedValue = UserDefaults.standard.string(forKey: storageKey),
           let storedLanguage = AppLanguage(rawValue: storedValue)
        {
            selectedLanguage = storedLanguage
        } else {
            selectedLanguage = AppLanguage.defaultLanguage
        }

        L10n.setLanguage(selectedLanguage)
    }
}
