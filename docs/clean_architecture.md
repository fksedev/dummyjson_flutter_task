# DummyJSON Flutter Task — clean architecture

Source of truth for feature layout, API layering, security, and **Bloc/Cubit** state management in this project.

Also follow [`docs/code_rules.md`](code_rules.md) for UI size, ScreenUtil, and hygiene.

**Approach:** Feature-first folders + Clean Architecture (presentation / domain / data), with Cubits as the presentation state layer. Aligned with [Flutter’s architecture guide](https://docs.flutter.dev/app-architecture/guide).

---

## Goals

- Organize by **feature**, not by global type folders. Every feature owns **`presentation`**, **`domain`**, and **`data`**.
- Keep UI thin: views render state and dispatch Cubit events/commands; they do not call HTTP or parse JSON.
- Use **Bloc/Cubit** as the only app-wide state management.
- Isolate domain rules from Flutter/Dio; keep DTOs and services in data.
- Call APIs through a **multi-layered** stack so secrets, tokens, and transport never leak into UI or domain.

---

## Feature-first rule (required)

**Every feature** under `lib/features/<feature_name>/` must include these three sections:

```text
lib/features/<feature>/
├── presentation/     # Screens/widgets + Cubits
├── domain/           # Entities, repository contracts, use cases, failures
└── data/             # DTOs/models, services, repository implementations
```

| Section | Required? | Role |
|---------|-----------|------|
| **presentation** | Always | Screens, widgets, Cubits |
| **domain** | Always | Entities + abstract repositories; use cases when needed |
| **data** | Always | Models/DTOs, remote/local services, `RepositoryImpl` |

Shared cross-feature code goes in **`lib/core`** or **`lib/shared`**.

---

## Layers & dependency rule

```text
View → Cubit → (UseCase?) → Repository (abstract)
                                  ↑
                           RepositoryImpl
                                  ↓
                     Service (remote / local)
                                  ↓
                     core/network ApiClient + interceptors
```

| Layer | May depend on | Must not depend on |
|-------|---------------|--------------------|
| **Presentation** | Same-feature domain, `core`, Flutter, Bloc | Other features’ `data/`, Dio, raw JSON |
| **Domain** | Dart only (no Flutter) | `data/`, presentation, Dio, storage packages |
| **Data** | Same-feature domain, `core` | Presentation / widgets |
| **Core / shared** | Flutter / packages as needed | Feature presentation |

**Rules**

- Outer layers depend on **abstractions** (repository interfaces in `domain/`).
- Domain never imports `data/` or presentation.
- Features should not import another feature’s `data/` or internal presentation.
- Repositories must **not** depend on other repositories. Combine in a Cubit or use case.

---

## Folder structure

```text
lib/
├── main.dart
├── app.dart
├── core/
│   ├── di/                           # get_it registrations
│   ├── network/                      # Dio client, interceptors
│   │   ├── api_client.dart
│   │   ├── api_endpoints.dart
│   │   └── interceptors/
│   ├── security/                     # Secure token store
│   ├── config/                       # Base URLs
│   ├── errors/                       # Failures / exception mapping
│   ├── theme/                        # AppColors, AppTextStyles, AppTheme
│   └── constants/
├── shared/
│   └── widgets/
└── features/
    ├── auth/
    │   ├── presentation/
    │   │   ├── screens/
    │   │   ├── widgets/
    │   │   └── cubit/
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── use_cases/
    │   └── data/
    │       ├── models/
    │       ├── services/
    │       └── repositories/
    └── products/
        ├── presentation/
        │   ├── screens/
        │   ├── widgets/
        │   └── cubit/
        ├── domain/
        └── data/
```

### Naming

| Kind | Example |
|------|---------|
| Feature folder | `auth`, `products` (snake_case) |
| Entity | `User`, `Product` |
| DTO / model | `UserDto`, `ProductDto` |
| Repository interface | `AuthRepository`, `ProductRepository` |
| Repository impl | `AuthRepositoryImpl` |
| Service | `AuthRemoteService`, `ProductRemoteService` |
| Use case | `Login`, `GetProducts` |
| Cubit | `LoginCubit`, `ProductListCubit` |
| Screen | `LoginScreen`, `ProductListScreen` |

Prefer `package:dummyjson_flutter_task/...` imports.

---

## Bloc / Cubit conventions

### Packages

- `flutter_bloc` — required.
- `equatable` — for state equality.
- Prefer **Cubit** for this app (imperative commands). Use full Bloc when event streams add clear value.

### Placement

| Kind | Location |
|------|----------|
| ApiClient, token store, shared DI | `lib/core/di/` via `get_it` |
| Feature services, repos, use cases | Inside that feature (`data/` / `domain/`) |
| Cubits | `presentation/cubit/` |

### Rules

- Screens: `BlocProvider` / `BlocBuilder` / `BlocListener` / `BlocConsumer`.
- Mutations: call Cubit methods from UI (`context.read<LoginCubit>().login(...)`).
- Cubits never construct Dio or call raw `http`.
- Cubits depend on repository interfaces or use cases only.
- Provide Cubits at the route/screen boundary (or above when shared).

### When to add use cases

Add a use case when **one or more** hold:

1. Logic merges **multiple repositories**
2. Logic is **complex**
3. Logic is **reused** across multiple Cubits

Otherwise Cubits may call the repository interface directly.

---

## Multi-layered API stack (security)

```text
View → Cubit → (UseCase?) → Repository → Service → ApiClient → Interceptors → TLS
```

| Layer | Security responsibility |
|-------|-------------------------|
| **Presentation** | Never log tokens or PII in release. |
| **Domain** | Authorize intent via repository results, not by reading tokens. |
| **RepositoryImpl** | Clear session on failed refresh / hard `401`. |
| **RemoteService** | No auth headers; path + body + query only via `ApiClient`. |
| **ApiClient** | Base URL; timeouts; content-type. |
| **AuthInterceptor** | Secure storage token; single-flight refresh; logout on failure. |
| **LoggingInterceptor** | Debug only; redact `Authorization` and tokens. |
| **Secure storage** | Access/refresh tokens — never plain prefs. |

### Auth token flow

```text
Login
  → Auth repository stores tokens via SecureTokenStore
  → AuthInterceptor attaches Bearer
  → 401 → refresh once (single-flight) → retry or clear session → Login
```

---

## Feature checklist

1. Create `lib/features/<name>/{presentation,domain,data}`.
2. Add **entities** + **repository interface** in `domain/`.
3. Add **DTO** + **RemoteService** in `data/` using `ApiClient` only.
4. Implement **RepositoryImpl** with mapping and failure handling.
5. Add **use case** only if merge/complex/reuse applies.
6. Add **Cubit** + **screen/widgets** under `presentation/`.
7. Register DI; wire loading / error / empty UI.
8. No Dio in views; UI &lt; 200 lines ([`code_rules.md`](code_rules.md)).

---

## Anti-patterns (do not)

- Calling Dio / `http` from a View or Cubit.
- Skipping `data/services` and putting HTTP inside `RepositoryImpl` without a service boundary.
- Global `lib/domain` / `lib/data` for feature code.
- Feature without one of `presentation` / `domain` / `data`.
- `fromJson` on domain entities; DTO extending entity as the only model.
- Importing `data/` from `domain/`.
- Tokens in plain `SharedPreferences` or constants.
- Logging auth headers in release.
- Mixing Riverpod / GetX with Bloc for app state in this project.
