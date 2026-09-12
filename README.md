# Swift Learning

Swift Learning is an iOS app for learning Swift through lessons, quizzes, code tasks, and practice exercises.

The app includes authentication, course progress tracking, profile statistics, achievements, localization, and light/dark theme support.

## Demo

https://github.com/user-attachments/assets/ec937e74-14fb-4bcd-afd7-0d5c3a519f53


## Features

- Learn tab with Swift Basics lessons and course progress.
- Lesson flow with theory, code examples, quiz questions, and code tasks.
- Practice tab with topic-based exercises and result summaries.
- Profile tab with progress, statistics, achievements, and logout.
- Settings menu with language and theme selection.
- English and Russian localization.
- Light, dark, and system theme modes.
- Centralized semantic color system through `AppColors`.
- Token-based networking with Keychain-backed token storage.

## App Structure

The project follows a feature-oriented SwiftUI structure:

```text
SwiftLearning/
  App/                  Root coordinators and tab navigation
  Components/           Reusable UI components
  Core/                 Design, localization, auth, networking, pagination
  Data/Services/        API service layer
  Domain/Managers/      Feature data managers and loading state
  Features/
    Auth/               Sign in and registration
    Learn/              Lessons, quizzes, code tasks, completion result
    Practice/           Practice topics, sessions, results
    Profile/            Profile screen, settings, language/theme selection
```

## Architecture

- SwiftUI views are grouped by feature.
- Navigation is handled by feature coordinators and routers.
- App-wide dependencies are assembled in `AppDependenciesAssembler`.
- API calls go through `NetworkManager` and typed service classes.
- Loading, content, empty, and error states are modeled explicitly.
- Shared UI styling is centralized in `Core/Design`.

Views should use semantic colors from `AppColors` instead of hardcoded colors. Theme switching is handled centrally, so feature views do not need to check the active color scheme.

## Requirements

- Xcode
- iOS Simulator or device
- Backend API compatible with the app endpoints

## Getting Started

1. Open `SwiftLearning.xcodeproj` in Xcode.
2. Select the `SwiftLearning` scheme.
3. Configure the API base URL if needed.
4. Build and run the app.

By default, the app uses:

```text
http://127.0.0.1:8000
```

You can override it with `API_BASE_URL` through an environment variable or the app Info.plist.

## Configuration

`AppConfiguration` reads the API base URL in this order:

1. `API_BASE_URL` from the process environment.
2. `API_BASE_URL` from the app bundle Info.plist.
3. Default value: `http://127.0.0.1:8000`.

## Localization

Localization is stored in:

- `en.lproj/Localizable.strings`
- `ru.lproj/Localizable.strings`

The selected language is persisted in `UserDefaults` through `LanguageSettings`.

## Themes

The app supports:

- System
- Light
- Dark

Theme selection is persisted in `UserDefaults` through `ThemeSettings`.

Semantic colors live in `AppColors` and automatically adapt between light and dark mode.

## Testing

Run tests from Xcode using the active scheme test action.

## Development Notes

- Prefer `AppColors` for all UI colors.
- Prefer shared view modifiers from `AppViewModifiers` for cards, inputs, buttons, forms, navigation, and tab containers.
- Keep feature-specific navigation inside the corresponding router/coordinator.
- Keep user-facing strings in localization files.
