# Code rules

Conventions for Flutter UI and code hygiene in this project.

For structure, APIs, security layering, and Bloc/Cubit, follow [`docs/clean_architecture.md`](clean_architecture.md).

## File size

| Kind | Limit |
|------|-------|
| **UI** — screens & widgets under `presentation/screens/`, `presentation/widgets/`, `lib/shared/widgets/` | **under 200 lines** |
| **Helpers** — pure Dart helpers extracted from widgets | **under 500 lines** |
| **Repos / DTOs / models / services / entities / Cubits / domain & data** | **no line-count split** |

### UI (&lt; 200)

- Prefer small, focused widgets over large screen files.
- Split by section or responsibility (header, list, card, footer, form fields).
- Screens compose widgets; widgets do one job.

## Sizing and fonts (`flutter_screenutil`)

- Design base is **402 × 874** ([`AppDimens`](../lib/core/constants/app_dimens.dart)).
- Use `flutter_screenutil` for layout sizes: `.w`, `.h`, `.r`, `.sp`.
- **Widths → `.w`, heights → `.h`**.
- Do **not** hard-code raw logical pixels for padding, gaps, radii, heights, or font sizes in UI.
- Prefer `AppTextStyles.mono` / shared styles over ad-hoc `TextStyle` when possible.
- Prefer `AppColors` over raw `Color(0xFF...)` for repeated brand/UI colors.

## Typography (`google_fonts`)

- Use **`google_fonts`** at runtime — **Roboto Mono** (`AppTextStyles.mono` / `GoogleFonts.robotoMono`).
- Do **not** add or commit font files under `assets/fonts/`.
- Do **not** register a `fonts:` section in `pubspec.yaml` for UI typefaces.

## Code cleanliness

1. Format touched Dart files: `dart format lib`
2. Analyze until clean: `dart analyze lib`
3. Fix every reported issue.

## Structure and style

- **Feature-first** under `lib/features/<feature>/` with **`presentation/`**, **`domain/`**, and **`data/`**.
- UI lives in `presentation/screens/` and `presentation/widgets/`; Cubits in `presentation/cubit/`.
- Multi-screen features use **one folder per screen** with a local `widgets/` folder.
- Prefer `package:dummyjson_flutter_task/...` imports.
- Shared widgets in `lib/shared/widgets/`.
- Shared theme in `lib/core/theme/`.
- Do not commit unless asked.

## Checklist

- [ ] UI screens/widgets under 200 lines
- [ ] Sizes and fonts use ScreenUtil (`.w` / `.h` / `.r` / `.sp`)
- [ ] Colors/styles prefer `AppColors` / `AppTextStyles`
- [ ] Typography via `google_fonts` (Roboto Mono)
- [ ] `dart format` applied
- [ ] `dart analyze lib` reports **no** issues
