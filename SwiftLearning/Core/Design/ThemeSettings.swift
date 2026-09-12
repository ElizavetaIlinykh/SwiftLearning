import Foundation
import Observation

@Observable
final class ThemeSettings {
    // MARK: - Private properties -

    private let storageKey = "app.selectedTheme"

    // MARK: - Public properties -

    var selectedTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: storageKey)
        }
    }

    // MARK: - Init -

    init() {
        if let storedValue = UserDefaults.standard.string(forKey: storageKey),
           let storedTheme = AppTheme(rawValue: storedValue)
        {
            selectedTheme = storedTheme
        } else {
            selectedTheme = .system
        }
    }
}
