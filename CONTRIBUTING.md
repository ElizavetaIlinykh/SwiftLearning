# SwiftLearning Architecture Rules

This project uses a SwiftUI MVVM-C style architecture with manual dependency injection.

The default dependency direction for feature code is:

```text
View -> ViewModel -> Manager/UseCase -> Service -> Network
```

Dependencies should point only to the next layer when possible. UI code should not call API services or networking directly.

## Layers

The main source folders follow the same layer split:

```text
Core/      Shared infrastructure: auth state, token storage, networking, pagination, error mapping.
Data/      Backend API services and service protocols.
Domain/    Feature workflows/managers and reusable domain loading state.
Screens/   Feature UI, navigation, assemblers, view models, and builders.
Models/    App and backend data models.
Components/Reusable SwiftUI components.
```

### View

SwiftUI views render state and forward user actions.

Views should:

- Own only local presentation state, such as focused fields or temporary UI flags.
- Read screen state from a ViewModel.
- Trigger ViewModel methods for user actions and lifecycle events.
- Avoid networking, persistence, business rules, and response mapping.

### ViewModel

ViewModels prepare screen state and coordinate user actions.

ViewModels should:

- Expose a small public state, usually a `ViewState`.
- Convert manager/use case results into screen state.
- Use builders to map domain models into component view models.
- Emit navigation or feature outputs through closures.
- Avoid direct `NetworkManaging` usage.
- Avoid direct service usage when a Manager/UseCase exists for that feature flow.

### Manager / UseCase

Managers or use cases contain feature workflows that are larger than a single API call.

They should:

- Coordinate loading, refresh, pagination, saving, and retry behavior.
- Own request cancellation and in-memory feature caches when needed.
- Combine multiple service calls into one feature result.
- Keep UI state out of the domain workflow.

Use a Manager/UseCase when:

- The screen needs pagination.
- Multiple API calls are combined.
- The same workflow may be reused by more than one ViewModel.
- The workflow has loading, retry, cancellation, or caching rules.

### Service

Services represent backend API areas.

Services should:

- Be accessed through protocols such as `LessonsServicing` or `PracticeServicing`.
- Build endpoint paths and request bodies.
- Map backend-specific API errors when appropriate.
- Avoid UI state and navigation decisions.

Services live under `Data/Services`.

### Network

The network layer owns HTTP transport details.

It should:

- Build and send requests.
- Decode responses.
- Attach authentication headers.
- Surface transport/server/decoding errors.
- Avoid feature-specific business decisions.

Networking, auth infrastructure, pagination helpers, and shared error mapping live under `Core`.

## Feature Module Shape

New feature screens should generally follow this structure:

```text
Feature/
  Assembler/
  Navigation/
  View/
    Builders/
    ViewModels/
  ViewModel/
```

For small screens, keep the structure proportional, but preserve the dependency direction.

## Navigation

Navigation belongs to coordinators and routers.

Feature ViewModels should emit outputs such as `openLesson`, `openResult`, or `logoutRequested`. Coordinators decide how those outputs change navigation or app-level state.

## Builders

Builders map domain/network models into UI-specific view models.

Builders should:

- Be deterministic and side-effect free.
- Contain formatting and presentation mapping.
- Avoid async work, service calls, navigation, and persistence.

## Practical Rules

- Do not call `NetworkManager` from Views or ViewModels.
- Do not call API services from Views.
- Prefer a Manager/UseCase between a ViewModel and Service when the workflow is more than one simple request.
- Keep `SessionState` and other app-level state at coordinator/composition boundaries when possible.
- Keep reusable UI in `Components`.
- Keep backend DTOs and app models in `Models`.
- Add tests for ViewModels, builders, managers, and error mapping when changing behavior.

## App Configuration

App-wide configuration lives in `Core/Configuration`.

`AppConfiguration` owns the API base URL. It reads `API_BASE_URL` from the process environment first, then from Info.plist, and falls back to the local development server URL.

`NetworkManager` should receive its `baseURL` from `AppDependenciesAssembler`; do not add feature-specific base URLs or hardcoded backend hosts in services.
