# DummyJSON Flutter Task

Small Flutter take-home against the public [DummyJSON](https://dummyjson.com) API.

Built to show a **production-style approach**: feature-first clean architecture, **Bloc/Cubit** state management, secure auth, and explicit loading / error / empty UI states.

---

## Task checklist (`docs/task.md`)

| Requirement | Status |
|-------------|--------|
| Login (`POST /auth/login`) with `emilys` / `emilyspass` | Done |
| Store token securely | Done (`flutter_secure_storage`) |
| Product list (`GET /products`) | Done |
| Loading / error / empty states | Done (shimmer + error/empty UI) |
| Pull-to-refresh | Done |
| Pagination | Done (`limit` / `skip`, infinite scroll) |
| Product detail on tap | Done |
| Clean architecture + state management | Done (Clean Architecture + Cubit) |
| README explaining decisions | Done (this file) |

---

## Run the app

```bash
flutter pub get
flutter run
```

### Test credentials

| Field | Value |
|-------|-------|
| Username | `emilys` |
| Password | `emilyspass` |

Credentials are pre-filled on the login screen.

---

## What the app does

### Required by the task

1. **Login** — `POST /auth/login` (`expiresInMins: 30`)
2. **Secure session** — access + refresh tokens in secure storage
3. **Product catalog** — `GET /products` with shimmer loading, error, empty, pull-to-refresh, pagination
4. **Product detail** — tap a product → detail screen (`GET /products/:id`)

### Extra (beyond the brief, for a stronger production demo)

- `GET /auth/me` — current user profile (avatar menu)
- `POST /auth/refresh` — manual refresh from profile menu + automatic single-flight refresh on `401`
- `GET /products/search?q=` — debounced search with pagination
- Richer detail fields (tags, reviews, shipping, warranty, dimensions, etc.)

---

## Architecture decisions

### Clean architecture (feature-first)

```text
lib/
├── core/           # ApiClient, interceptors, secure storage, DI, theme, errors
├── shared/widgets/ # Shared UI (buttons, empty/error, shimmer)
└── features/
    ├── auth/       # presentation / domain / data
    └── products/   # presentation / domain / data
```

Dependency rule:

```text
UI → Cubit → UseCase? → Repository (interface)
                              ↑
                       RepositoryImpl → RemoteService → ApiClient → Interceptors
```

| Layer | Responsibility |
|-------|----------------|
| **Presentation** | Screens/widgets + Cubits — no Dio/JSON |
| **Domain** | Entities, repository contracts, use cases — pure Dart |
| **Data** | DTOs (`fromJson` / `toEntity`), remote services, repository impls |
| **Core** | Network, security, DI, theme — shared infrastructure |

UI screens/widgets stay **under 200 lines** (see [`docs/code_rules.md`](docs/code_rules.md)).

### Why Bloc/Cubit

- Separates UI from business logic
- Makes loading / success / empty / error transitions explicit and testable
- Fits multi-feature apps well and matches how I usually deliver Flutter projects
- Cubits keep the API simple for this screen set

### Auth & tokens

1. Login stores `accessToken` + `refreshToken` securely
2. `AuthInterceptor` attaches `Authorization: Bearer <accessToken>`
3. On `401` → `POST /auth/refresh` (single-flight) → retry original request
4. If refresh fails → clear tokens → return to login
5. After login / bootstrap → `GET /auth/me` for the profile avatar menu

### API client approach

DummyJSON is a small public API, so the client is **hand-written** with Dio (not generated). Services are isolated from UI/domain, so swapping to OpenAPI codegen later is straightforward.

---

## Key packages

| Package | Role |
|---------|------|
| `flutter_bloc` | State management (Cubit) |
| `dio` | HTTP |
| `flutter_secure_storage` | Secure token storage |
| `get_it` | DI |
| `flutter_screenutil` | Responsive layout |
| `google_fonts` | Typography (Roboto Mono) |
| `cached_network_image` | Product / avatar images |
| `shimmer` | Loading skeletons |
| `equatable` | Value equality for states/entities |

---

## How to review quickly

1. Run the app and sign in with the pre-filled credentials
2. Confirm catalog loading (shimmer), pull-to-refresh, and scroll pagination
3. Search for `phone`
4. Open a product detail
5. Tap the avatar → profile info, **Refresh session**, **Sign out**
6. Kill & relaunch to confirm session restore via stored token + `/auth/me`

---

## Project docs

- [`docs/task.md`](docs/task.md) — original brief
- [`docs/clean_architecture.md`](docs/clean_architecture.md) — architecture rules
- [`docs/code_rules.md`](docs/code_rules.md) — UI size / ScreenUtil / hygiene

---

## Author

**Faizan Khaliq** — Senior Flutter Developer  
Portfolio: https://fksedev.github.io/portfolio/
