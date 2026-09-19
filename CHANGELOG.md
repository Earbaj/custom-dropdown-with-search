# Changelog

## 1.1.0

### Fixes & Improvements
- **Fixed package name mismatch**: Renamed package in `pubspec.yaml` to `customedropdownlistwithsearch` matching the pub.dev release, and fixed import paths in documentation.
- **Added repository metadata**: Added `homepage`, `repository`, and `issue_tracker` links to `pubspec.yaml` to improve pub score and community trust.
- **Removed `provider` dependency**: Removed external `provider` requirement. The widget now auto-detects dark and light mode themes directly via `Theme.of(context)`, eliminating `ProviderNotFoundException` and significantly lightening the package footprint.
- **Upgraded dependencies**: Upgraded `animated_custom_dropdown` to `^4.0.0` and `flutter_lints` to `^4.0.0`.
- **Fixed documentation duplication**: Removed duplicated `CustomDropdownDecoration` section from `README.md` and added comprehensive examples with badges and API references.

### New Features
- **Multi-select support**: Added `CustomDropdownSearch.multiSelectSearch` and `CustomDropdownMultiSearch` for multiple item selections.
- **Async / Remote search**: Added `CustomDropdownSearch.searchRequest` with configurable debounce (`futureRequestDelay`) and customizable loading indicators.
- **Infinite scroll / Pagination**: Added `CustomDropdownSearch.paginated` and `multiSelectPaginated` for lazy-loading large datasets.
- **Custom Item & Header Builders**: Added `listItemBuilder`, `headerBuilder`, `headerListBuilder`, `hintBuilder`, and `noResultFoundBuilder` for full widget customization (avatars, icons, subtitles).
- **Clear / Reset Button**: Built-in support for clearing selections (`canClearSelection: true`) and controller-based state management (`SingleSelectController`, `MultiSelectController`).
- **Form validation**: Added `validator` and `listValidator` support that seamlessly integrates with Flutter `Form` and `FormField`.
- **Grouping / Categorized items**: Added `groupBy` and `groupHeaderBuilder` for dividing items into categorized sections.
- **Comprehensive test suite**: Added unit and widget tests covering single-select, multi-select, form validation, theming, builders, and controllers.

## 1.0.1
* Initial public release on pub.dev.
