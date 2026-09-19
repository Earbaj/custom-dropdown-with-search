import 'dart:async';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Export useful types from animated_custom_dropdown for consumer convenience
export 'package:animated_custom_dropdown/custom_dropdown.dart'
    show
        CustomDropdown,
        CustomDropdownDecoration,
        CustomDropdownDisabledDecoration,
        SearchFieldDecoration,
        ListItemDecoration,
        SingleSelectController,
        MultiSelectController,
        DropdownOverlayDirection,
        CustomDropdownAnimation,
        PaginatedSearchRequest;

export 'provider/theme_provider.dart';

/// Item builder typedef for custom dropdown items.
typedef DropdownListItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  bool isSelected,
  VoidCallback onItemSelect,
);

/// Header builder typedef for single-selection header field.
typedef DropdownHeaderBuilder<T> = Widget Function(
  BuildContext context,
  T selectedItem,
  bool enabled,
);

/// Header builder typedef for multi-selection header field.
typedef DropdownHeaderListBuilder<T> = Widget Function(
  BuildContext context,
  List<T> selectedItems,
  bool enabled,
);

/// Hint builder typedef.
typedef DropdownHintBuilder = Widget Function(
  BuildContext context,
  String hint,
  bool enabled,
);

/// No result found builder typedef.
typedef DropdownNoResultBuilder = Widget Function(
  BuildContext context,
  String text,
);

/// Group header builder typedef for categorized dropdowns.
typedef DropdownGroupHeaderBuilder = Widget Function(
  BuildContext context,
  String category,
);

enum _CustomDropdownMode {
  singleSearch,
  singleSearchRequest,
  singlePaginated,
  multiSearch,
  multiSearchRequest,
  multiPaginated,
}

/// A highly customizable, searchable dropdown widget supporting single and multi-selection,
/// async/remote search with debounce, custom builders, form validation, categorization,
/// clear buttons, and dark mode theming without external state management dependencies.
class CustomDropdownSearch<T> extends StatelessWidget {
  /// The list of items for the dropdown.
  final List<T>? items;

  /// Initial selected item for single selection.
  final T? initialItem;

  /// Initial selected items for multi-selection.
  final List<T>? initialItems;

  /// Callback when the selected item changes in single selection mode.
  final ValueChanged<T?>? onChanged;

  /// Callback when selected items change in multi-selection mode.
  final ValueChanged<List<T>>? onListChanged;

  /// Text that suggests what sort of data the dropdown represents.
  final String hintText;

  /// Text that suggests what to search in the search field.
  final String searchHintText;

  /// Text to display when no search results match.
  final String noResultFoundText;

  /// Custom decoration for the dropdown.
  /// If omitted or partially set, automatically adapts to the current Theme (Dark/Light mode).
  final CustomDropdownDecoration? decoration;

  /// Disabled state decoration.
  final CustomDropdownDisabledDecoration? disabledDecoration;

  /// Whether the dropdown is enabled.
  final bool enabled;

  /// Controller for single-select dropdown state.
  final SingleSelectController<T?>? controller;

  /// Controller for multi-select dropdown state.
  final MultiSelectController<T>? multiSelectController;

  /// Controller to programmatically show or hide the dropdown overlay.
  final OverlayPortalController? overlayController;

  /// ScrollController for the dropdown items list.
  final ScrollController? itemsScrollController;

  /// Form validator for single selection.
  final FormFieldValidator<T>? validator;

  /// Form validator for multi-selection.
  final FormFieldValidator<List<T>>? listValidator;

  /// Whether to validate on item selection change.
  final bool validateOnChange;

  /// Builder for rendering each item in the list.
  final DropdownListItemBuilder<T>? listItemBuilder;

  /// Builder for rendering the closed/selected header for single selection.
  final DropdownHeaderBuilder<T>? headerBuilder;

  /// Builder for rendering the closed/selected header for multi-selection.
  final DropdownHeaderListBuilder<T>? headerListBuilder;

  /// Builder for rendering the placeholder hint.
  final DropdownHintBuilder? hintBuilder;

  /// Builder for rendering the no-results-found view.
  final DropdownNoResultBuilder? noResultFoundBuilder;

  /// Optional grouping function. Given an item, returns its category label.
  /// Items will be displayed grouped by category.
  final String Function(T item)? groupBy;

  /// Builder for rendering category headers when [groupBy] is used.
  final DropdownGroupHeaderBuilder? groupHeaderBuilder;

  /// Async function for remote search with query string.
  final Future<List<T>> Function(String query)? futureRequest;

  /// Debounce delay before executing [futureRequest]. Defaults to 300ms.
  final Duration? futureRequestDelay;

  /// Minimum characters before triggering [futureRequest]. Defaults to 0.
  final int searchRequestMinChars;

  /// Loading widget displayed during async search.
  final Widget? searchRequestLoadingIndicator;

  /// Page-aware async request for infinite scroll / pagination.
  final PaginatedSearchRequest<T>? paginatedRequest;

  /// Items per page for paginated request. Defaults to 20.
  final int pageSize;

  /// Widget shown at bottom of list while next page loads.
  final Widget? loadMoreIndicator;

  /// Whether to show a clear button (X) when an item is selected.
  final bool canClearSelection;

  /// Whether to provide haptic feedback when an item is selected.
  final bool enableHapticFeedback;

  /// Maximum lines for header and item text.
  final int maxLines;

  /// Overlay height for expanded dropdown list.
  final double? overlayHeight;

  /// Direction to open overlay (auto, below, above).
  final DropdownOverlayDirection overlayDirection;

  /// Whether tapping outside the dropdown bounds closes it.
  final bool canCloseOutsideBounds;

  /// Whether to hide the header field when expanded.
  final bool hideSelectedFieldWhenExpanded;

  /// Whether to exclude selected item from the items list.
  final bool excludeSelected;

  /// Autofocus the search field when opened.
  final bool autofocusOnSearch;

  /// Outer padding for the widget.
  final EdgeInsetsGeometry padding;

  /// Floating label text (Material 3 style).
  final String? labelText;

  /// Floating label custom widget.
  final Widget? label;

  final _CustomDropdownMode _mode;

  /// Default constructor: Single-selection searchable dropdown.
  const CustomDropdownSearch({
    super.key,
    required this.items,
    required this.onChanged,
    this.initialItem,
    this.controller,
    this.hintText = 'Select an option',
    this.searchHintText = 'Search...',
    this.noResultFoundText = 'No result found.',
    this.decoration,
    this.disabledDecoration,
    this.enabled = true,
    this.validator,
    this.validateOnChange = true,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.groupBy,
    this.groupHeaderBuilder,
    this.canClearSelection = true,
    this.enableHapticFeedback = true,
    this.maxLines = 1,
    this.overlayHeight,
    this.overlayDirection = DropdownOverlayDirection.auto,
    this.overlayController,
    this.itemsScrollController,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.excludeSelected = true,
    this.autofocusOnSearch = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0),
    this.labelText,
    this.label,
  })  : initialItems = null,
        onListChanged = null,
        multiSelectController = null,
        listValidator = null,
        headerListBuilder = null,
        futureRequest = null,
        futureRequestDelay = null,
        searchRequestMinChars = 0,
        searchRequestLoadingIndicator = null,
        paginatedRequest = null,
        pageSize = 20,
        loadMoreIndicator = null,
        _mode = _CustomDropdownMode.singleSearch;

  /// Multi-selection searchable dropdown.
  const CustomDropdownSearch.multiSelectSearch({
    super.key,
    required this.items,
    required this.onListChanged,
    this.initialItems,
    this.multiSelectController,
    this.hintText = 'Select options',
    this.searchHintText = 'Search...',
    this.noResultFoundText = 'No result found.',
    this.decoration,
    this.disabledDecoration,
    this.enabled = true,
    this.listValidator,
    this.validateOnChange = true,
    this.listItemBuilder,
    this.headerListBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.groupBy,
    this.groupHeaderBuilder,
    this.canClearSelection = true,
    this.enableHapticFeedback = true,
    this.maxLines = 1,
    this.overlayHeight,
    this.overlayDirection = DropdownOverlayDirection.auto,
    this.overlayController,
    this.itemsScrollController,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.excludeSelected = false,
    this.autofocusOnSearch = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0),
    this.labelText,
    this.label,
  })  : initialItem = null,
        onChanged = null,
        controller = null,
        validator = null,
        headerBuilder = null,
        futureRequest = null,
        futureRequestDelay = null,
        searchRequestMinChars = 0,
        searchRequestLoadingIndicator = null,
        paginatedRequest = null,
        pageSize = 20,
        loadMoreIndicator = null,
        _mode = _CustomDropdownMode.multiSearch;

  /// Async / Remote search with query string and debounce for single-selection.
  const CustomDropdownSearch.searchRequest({
    super.key,
    required this.futureRequest,
    required this.onChanged,
    this.initialItem,
    this.controller,
    this.futureRequestDelay = const Duration(milliseconds: 300),
    this.searchRequestMinChars = 0,
    this.searchRequestLoadingIndicator,
    this.hintText = 'Select an option',
    this.searchHintText = 'Search...',
    this.noResultFoundText = 'No result found.',
    this.decoration,
    this.disabledDecoration,
    this.enabled = true,
    this.validator,
    this.validateOnChange = true,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.canClearSelection = true,
    this.enableHapticFeedback = true,
    this.maxLines = 1,
    this.overlayHeight,
    this.overlayDirection = DropdownOverlayDirection.auto,
    this.overlayController,
    this.itemsScrollController,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.excludeSelected = true,
    this.autofocusOnSearch = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0),
    this.labelText,
    this.label,
  })  : items = null,
        initialItems = null,
        onListChanged = null,
        multiSelectController = null,
        listValidator = null,
        headerListBuilder = null,
        groupBy = null,
        groupHeaderBuilder = null,
        paginatedRequest = null,
        pageSize = 20,
        loadMoreIndicator = null,
        _mode = _CustomDropdownMode.singleSearchRequest;

  /// Async / Remote search with query string and debounce for multi-selection.
  const CustomDropdownSearch.multiSelectSearchRequest({
    super.key,
    required this.futureRequest,
    required this.onListChanged,
    this.initialItems,
    this.multiSelectController,
    this.futureRequestDelay = const Duration(milliseconds: 300),
    this.searchRequestMinChars = 0,
    this.searchRequestLoadingIndicator,
    this.hintText = 'Select options',
    this.searchHintText = 'Search...',
    this.noResultFoundText = 'No result found.',
    this.decoration,
    this.disabledDecoration,
    this.enabled = true,
    this.listValidator,
    this.validateOnChange = true,
    this.listItemBuilder,
    this.headerListBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.canClearSelection = true,
    this.enableHapticFeedback = true,
    this.maxLines = 1,
    this.overlayHeight,
    this.overlayDirection = DropdownOverlayDirection.auto,
    this.overlayController,
    this.itemsScrollController,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.excludeSelected = false,
    this.autofocusOnSearch = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0),
    this.labelText,
    this.label,
  })  : items = null,
        initialItem = null,
        onChanged = null,
        controller = null,
        validator = null,
        headerBuilder = null,
        groupBy = null,
        groupHeaderBuilder = null,
        paginatedRequest = null,
        pageSize = 20,
        loadMoreIndicator = null,
        _mode = _CustomDropdownMode.multiSearchRequest;

  /// Paginated / Infinite scroll dropdown for single selection.
  const CustomDropdownSearch.paginated({
    super.key,
    required this.paginatedRequest,
    required this.onChanged,
    this.initialItem,
    this.controller,
    this.pageSize = 20,
    this.loadMoreIndicator,
    this.futureRequestDelay = const Duration(milliseconds: 300),
    this.searchRequestMinChars = 0,
    this.searchRequestLoadingIndicator,
    this.hintText = 'Select an option',
    this.searchHintText = 'Search...',
    this.noResultFoundText = 'No result found.',
    this.decoration,
    this.disabledDecoration,
    this.enabled = true,
    this.validator,
    this.validateOnChange = true,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.canClearSelection = true,
    this.enableHapticFeedback = true,
    this.maxLines = 1,
    this.overlayHeight,
    this.overlayDirection = DropdownOverlayDirection.auto,
    this.overlayController,
    this.itemsScrollController,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.excludeSelected = true,
    this.autofocusOnSearch = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0),
    this.labelText,
    this.label,
  })  : items = null,
        initialItems = null,
        onListChanged = null,
        multiSelectController = null,
        listValidator = null,
        headerListBuilder = null,
        futureRequest = null,
        groupBy = null,
        groupHeaderBuilder = null,
        _mode = _CustomDropdownMode.singlePaginated;

  /// Paginated / Infinite scroll dropdown for multi-selection.
  const CustomDropdownSearch.multiSelectPaginated({
    super.key,
    required this.paginatedRequest,
    required this.onListChanged,
    this.initialItems,
    this.multiSelectController,
    this.pageSize = 20,
    this.loadMoreIndicator,
    this.futureRequestDelay = const Duration(milliseconds: 300),
    this.searchRequestMinChars = 0,
    this.searchRequestLoadingIndicator,
    this.hintText = 'Select options',
    this.searchHintText = 'Search...',
    this.noResultFoundText = 'No result found.',
    this.decoration,
    this.disabledDecoration,
    this.enabled = true,
    this.listValidator,
    this.validateOnChange = true,
    this.listItemBuilder,
    this.headerListBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.canClearSelection = true,
    this.enableHapticFeedback = true,
    this.maxLines = 1,
    this.overlayHeight,
    this.overlayDirection = DropdownOverlayDirection.auto,
    this.overlayController,
    this.itemsScrollController,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.excludeSelected = false,
    this.autofocusOnSearch = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0),
    this.labelText,
    this.label,
  })  : items = null,
        initialItem = null,
        onChanged = null,
        controller = null,
        validator = null,
        headerBuilder = null,
        futureRequest = null,
        groupBy = null,
        groupHeaderBuilder = null,
        _mode = _CustomDropdownMode.multiPaginated;

  /// Resolves the default theme decoration based on Flutter's [ThemeData] (light/dark mode).
  static CustomDropdownDecoration resolveDefaultDecoration(
    BuildContext context, {
    CustomDropdownDecoration? userDecoration,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultFill = isDark ? Colors.grey.shade900 : Colors.white;
    final defaultExpandedFill = isDark ? Colors.grey.shade900 : Colors.white;
    final defaultTextColor = isDark ? Colors.white : Colors.black87;
    final defaultHintColor = isDark ? Colors.white60 : Colors.grey.shade600;
    final defaultBorderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    final defaultSearchFill = isDark ? Colors.grey.shade800 : const Color(0xFFFAFAFA);
    final defaultSearchTextColor = isDark ? Colors.white : Colors.black87;
    final defaultSearchHintColor = isDark ? Colors.white54 : Colors.grey.shade500;

    final baseSearchDecoration = SearchFieldDecoration(
      fillColor: userDecoration?.searchFieldDecoration?.fillColor ?? defaultSearchFill,
      textStyle: userDecoration?.searchFieldDecoration?.textStyle ??
          TextStyle(color: defaultSearchTextColor, fontSize: 14),
      hintStyle: userDecoration?.searchFieldDecoration?.hintStyle ??
          TextStyle(color: defaultSearchHintColor, fontSize: 14),
      prefixIcon: userDecoration?.searchFieldDecoration?.prefixIcon ??
          Icon(Icons.search, color: defaultHintColor, size: 20),
      suffixIcon: userDecoration?.searchFieldDecoration?.suffixIcon,
      border: userDecoration?.searchFieldDecoration?.border ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: defaultBorderColor),
          ),
      focusedBorder: userDecoration?.searchFieldDecoration?.focusedBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
          ),
      constraints: userDecoration?.searchFieldDecoration?.constraints,
      contentPadding: userDecoration?.searchFieldDecoration?.contentPadding,
    );

    return CustomDropdownDecoration(
      closedFillColor: userDecoration?.closedFillColor ?? defaultFill,
      expandedFillColor: userDecoration?.expandedFillColor ?? defaultExpandedFill,
      headerStyle: userDecoration?.headerStyle ??
          TextStyle(color: defaultTextColor, fontSize: 14, fontWeight: FontWeight.w500),
      listItemStyle: userDecoration?.listItemStyle ??
          TextStyle(color: defaultTextColor, fontSize: 14),
      hintStyle: userDecoration?.hintStyle ??
          TextStyle(color: defaultHintColor, fontSize: 14),
      noResultFoundStyle: userDecoration?.noResultFoundStyle ??
          TextStyle(color: defaultHintColor, fontSize: 14),
      errorStyle: userDecoration?.errorStyle ??
          const TextStyle(color: Colors.redAccent, fontSize: 12),
      closedBorder: userDecoration?.closedBorder ??
          Border.all(color: defaultBorderColor),
      closedBorderRadius: userDecoration?.closedBorderRadius ?? BorderRadius.circular(12),
      expandedBorder: userDecoration?.expandedBorder ??
          Border.all(color: defaultBorderColor),
      expandedBorderRadius: userDecoration?.expandedBorderRadius ?? BorderRadius.circular(12),
      closedErrorBorder: userDecoration?.closedErrorBorder ??
          Border.all(color: Colors.redAccent, width: 1.2),
      closedErrorBorderRadius: userDecoration?.closedErrorBorderRadius ?? BorderRadius.circular(12),
      searchFieldDecoration: baseSearchDecoration,
      listItemDecoration: userDecoration?.listItemDecoration,
      closedSuffixIcon: userDecoration?.closedSuffixIcon,
      expandedSuffixIcon: userDecoration?.expandedSuffixIcon,
      prefixIcon: userDecoration?.prefixIcon,
      closedHeaderHeight: userDecoration?.closedHeaderHeight,
      labelStyle: userDecoration?.labelStyle,
      floatingLabelStyle: userDecoration?.floatingLabelStyle,
      floatingLabelBehavior: userDecoration?.floatingLabelBehavior ?? FloatingLabelBehavior.auto,
      floatingLabelGap: userDecoration?.floatingLabelGap ?? 16,
      overlayScrollbarDecoration: userDecoration?.overlayScrollbarDecoration,
    );
  }

  /// Helper to organize items into grouped list and generate grouped item builder.
  List<T> _processGroupedItems(List<T> sourceItems) {
    if (groupBy == null || sourceItems.isEmpty) return sourceItems;

    final groupedMap = <String, List<T>>{};
    for (final item in sourceItems) {
      final key = groupBy!(item);
      groupedMap.putIfAbsent(key, () => []).add(item);
    }

    final sortedItems = <T>[];
    for (final entry in groupedMap.entries) {
      sortedItems.addAll(entry.value);
    }
    return sortedItems;
  }

  Widget Function(BuildContext, T, bool, VoidCallback) _buildGroupedItemBuilder(
    List<T> processedItems,
    bool isDark,
  ) {
    final firstInGroupSet = <T>{};
    String? currentGroup;
    for (final item in processedItems) {
      final group = groupBy!(item);
      if (group != currentGroup) {
        firstInGroupSet.add(item);
        currentGroup = group;
      }
    }

    return (BuildContext context, T item, bool isSelected, VoidCallback onItemSelect) {
      final isFirst = firstInGroupSet.contains(item);
      final groupName = groupBy!(item);

      Widget itemWidget;
      if (listItemBuilder != null) {
        itemWidget = listItemBuilder!(context, item, isSelected, onItemSelect);
      } else {
        itemWidget = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            item.toString(),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        );
      }

      if (!isFirst) {
        return itemWidget;
      }

      final headerWidget = groupHeaderBuilder != null
          ? groupHeaderBuilder!(context, groupName)
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 6.0),
              color: isDark ? Colors.grey.shade800.withValues(alpha: 0.5) : Colors.grey.shade100,
              child: Text(
                groupName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                ),
              ),
            );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          headerWidget,
          itemWidget,
        ],
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedDecoration = resolveDefaultDecoration(context, userDecoration: decoration);

    // Prepare loading indicator
    final loadingIndicator = searchRequestLoadingIndicator ??
        Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        );

    // Handle grouping if items provided
    List<T>? effectiveItems = items;
    DropdownListItemBuilder<T>? effectiveItemBuilder = listItemBuilder;

    if (items != null && groupBy != null) {
      effectiveItems = _processGroupedItems(items!);
      effectiveItemBuilder = _buildGroupedItemBuilder(effectiveItems, isDark);
    }

    Widget dropdownWidget;

    switch (_mode) {
      case _CustomDropdownMode.singleSearch:
        dropdownWidget = CustomDropdown<T>.search(
          items: effectiveItems,
          onChanged: (value) {
            if (enableHapticFeedback) HapticFeedback.selectionClick();
            onChanged?.call(value);
          },
          initialItem: initialItem,
          controller: controller,
          hintText: hintText,
          searchHintText: searchHintText,
          noResultFoundText: noResultFoundText,
          decoration: resolvedDecoration,
          disabledDecoration: disabledDecoration,
          enabled: enabled,
          validator: validator,
          validateOnChange: validateOnChange,
          listItemBuilder: effectiveItemBuilder,
          headerBuilder: headerBuilder,
          hintBuilder: hintBuilder,
          noResultFoundBuilder: noResultFoundBuilder,
          canClearSelection: canClearSelection,
          maxlines: maxLines,
          overlayHeight: overlayHeight,
          overlayDirection: overlayDirection,
          overlayController: overlayController,
          itemsScrollController: itemsScrollController,
          canCloseOutsideBounds: canCloseOutsideBounds,
          hideSelectedFieldWhenExpanded: hideSelectedFieldWhenExpanded,
          excludeSelected: excludeSelected,
          autofocusOnSearch: autofocusOnSearch,
          labelText: labelText,
          label: label,
        );
        break;

      case _CustomDropdownMode.multiSearch:
        dropdownWidget = CustomDropdown<T>.multiSelectSearch(
          items: effectiveItems,
          onListChanged: (values) {
            if (enableHapticFeedback) HapticFeedback.selectionClick();
            onListChanged?.call(values);
          },
          initialItems: initialItems,
          multiSelectController: multiSelectController,
          hintText: hintText,
          searchHintText: searchHintText,
          noResultFoundText: noResultFoundText,
          decoration: resolvedDecoration,
          disabledDecoration: disabledDecoration,
          enabled: enabled,
          listValidator: listValidator,
          validateOnChange: validateOnChange,
          listItemBuilder: effectiveItemBuilder,
          headerListBuilder: headerListBuilder,
          hintBuilder: hintBuilder,
          noResultFoundBuilder: noResultFoundBuilder,
          canClearSelection: canClearSelection,
          maxlines: maxLines,
          overlayHeight: overlayHeight,
          overlayDirection: overlayDirection,
          overlayController: overlayController,
          itemsScrollController: itemsScrollController,
          canCloseOutsideBounds: canCloseOutsideBounds,
          hideSelectedFieldWhenExpanded: hideSelectedFieldWhenExpanded,
          autofocusOnSearch: autofocusOnSearch,
          labelText: labelText,
          label: label,
        );
        break;

      case _CustomDropdownMode.singleSearchRequest:
        dropdownWidget = CustomDropdown<T>.searchRequest(
          futureRequest: futureRequest,
          futureRequestDelay: futureRequestDelay,
          searchRequestMinChars: searchRequestMinChars,
          searchRequestLoadingIndicator: loadingIndicator,
          onChanged: (value) {
            if (enableHapticFeedback) HapticFeedback.selectionClick();
            onChanged?.call(value);
          },
          initialItem: initialItem,
          controller: controller,
          hintText: hintText,
          searchHintText: searchHintText,
          noResultFoundText: noResultFoundText,
          decoration: resolvedDecoration,
          disabledDecoration: disabledDecoration,
          enabled: enabled,
          validator: validator,
          validateOnChange: validateOnChange,
          listItemBuilder: effectiveItemBuilder,
          headerBuilder: headerBuilder,
          hintBuilder: hintBuilder,
          noResultFoundBuilder: noResultFoundBuilder,
          canClearSelection: canClearSelection,
          maxlines: maxLines,
          overlayHeight: overlayHeight,
          overlayDirection: overlayDirection,
          overlayController: overlayController,
          itemsScrollController: itemsScrollController,
          canCloseOutsideBounds: canCloseOutsideBounds,
          hideSelectedFieldWhenExpanded: hideSelectedFieldWhenExpanded,
          excludeSelected: excludeSelected,
          autofocusOnSearch: autofocusOnSearch,
          labelText: labelText,
          label: label,
        );
        break;

      case _CustomDropdownMode.multiSearchRequest:
        dropdownWidget = CustomDropdown<T>.multiSelectSearchRequest(
          futureRequest: futureRequest,
          futureRequestDelay: futureRequestDelay,
          searchRequestMinChars: searchRequestMinChars,
          searchRequestLoadingIndicator: loadingIndicator,
          onListChanged: (values) {
            if (enableHapticFeedback) HapticFeedback.selectionClick();
            onListChanged?.call(values);
          },
          initialItems: initialItems,
          multiSelectController: multiSelectController,
          hintText: hintText,
          searchHintText: searchHintText,
          noResultFoundText: noResultFoundText,
          decoration: resolvedDecoration,
          disabledDecoration: disabledDecoration,
          enabled: enabled,
          listValidator: listValidator,
          validateOnChange: validateOnChange,
          listItemBuilder: effectiveItemBuilder,
          headerListBuilder: headerListBuilder,
          hintBuilder: hintBuilder,
          noResultFoundBuilder: noResultFoundBuilder,
          canClearSelection: canClearSelection,
          maxlines: maxLines,
          overlayHeight: overlayHeight,
          overlayDirection: overlayDirection,
          overlayController: overlayController,
          itemsScrollController: itemsScrollController,
          canCloseOutsideBounds: canCloseOutsideBounds,
          hideSelectedFieldWhenExpanded: hideSelectedFieldWhenExpanded,
          autofocusOnSearch: autofocusOnSearch,
          labelText: labelText,
          label: label,
        );
        break;

      case _CustomDropdownMode.singlePaginated:
        dropdownWidget = CustomDropdown<T>.searchRequest(
          paginatedRequest: paginatedRequest,
          pageSize: pageSize,
          loadMoreIndicator: loadMoreIndicator,
          futureRequestDelay: futureRequestDelay,
          searchRequestMinChars: searchRequestMinChars,
          searchRequestLoadingIndicator: loadingIndicator,
          onChanged: (value) {
            if (enableHapticFeedback) HapticFeedback.selectionClick();
            onChanged?.call(value);
          },
          initialItem: initialItem,
          controller: controller,
          hintText: hintText,
          searchHintText: searchHintText,
          noResultFoundText: noResultFoundText,
          decoration: resolvedDecoration,
          disabledDecoration: disabledDecoration,
          enabled: enabled,
          validator: validator,
          validateOnChange: validateOnChange,
          listItemBuilder: effectiveItemBuilder,
          headerBuilder: headerBuilder,
          hintBuilder: hintBuilder,
          noResultFoundBuilder: noResultFoundBuilder,
          canClearSelection: canClearSelection,
          maxlines: maxLines,
          overlayHeight: overlayHeight,
          overlayDirection: overlayDirection,
          overlayController: overlayController,
          itemsScrollController: itemsScrollController,
          canCloseOutsideBounds: canCloseOutsideBounds,
          hideSelectedFieldWhenExpanded: hideSelectedFieldWhenExpanded,
          excludeSelected: excludeSelected,
          autofocusOnSearch: autofocusOnSearch,
          labelText: labelText,
          label: label,
        );
        break;

      case _CustomDropdownMode.multiPaginated:
        dropdownWidget = CustomDropdown<T>.multiSelectSearchRequest(
          paginatedRequest: paginatedRequest,
          pageSize: pageSize,
          loadMoreIndicator: loadMoreIndicator,
          futureRequestDelay: futureRequestDelay,
          searchRequestMinChars: searchRequestMinChars,
          searchRequestLoadingIndicator: loadingIndicator,
          onListChanged: (values) {
            if (enableHapticFeedback) HapticFeedback.selectionClick();
            onListChanged?.call(values);
          },
          initialItems: initialItems,
          multiSelectController: multiSelectController,
          hintText: hintText,
          searchHintText: searchHintText,
          noResultFoundText: noResultFoundText,
          decoration: resolvedDecoration,
          disabledDecoration: disabledDecoration,
          enabled: enabled,
          listValidator: listValidator,
          validateOnChange: validateOnChange,
          listItemBuilder: effectiveItemBuilder,
          headerListBuilder: headerListBuilder,
          hintBuilder: hintBuilder,
          noResultFoundBuilder: noResultFoundBuilder,
          canClearSelection: canClearSelection,
          maxlines: maxLines,
          overlayHeight: overlayHeight,
          overlayDirection: overlayDirection,
          overlayController: overlayController,
          itemsScrollController: itemsScrollController,
          canCloseOutsideBounds: canCloseOutsideBounds,
          hideSelectedFieldWhenExpanded: hideSelectedFieldWhenExpanded,
          autofocusOnSearch: autofocusOnSearch,
          labelText: labelText,
          label: label,
        );
        break;
    }

    return Padding(
      padding: padding,
      child: dropdownWidget,
    );
  }
}

/// Convenience class for multi-selection searchable dropdown.
class CustomDropdownMultiSearch<T> extends StatelessWidget {
  final List<T>? items;
  final ValueChanged<List<T>> onListChanged;
  final List<T>? initialItems;
  final MultiSelectController<T>? multiSelectController;
  final String hintText;
  final String searchHintText;
  final String noResultFoundText;
  final CustomDropdownDecoration? decoration;
  final CustomDropdownDisabledDecoration? disabledDecoration;
  final bool enabled;
  final FormFieldValidator<List<T>>? listValidator;
  final bool validateOnChange;
  final DropdownListItemBuilder<T>? listItemBuilder;
  final DropdownHeaderListBuilder<T>? headerListBuilder;
  final DropdownHintBuilder? hintBuilder;
  final DropdownNoResultBuilder? noResultFoundBuilder;
  final String Function(T item)? groupBy;
  final DropdownGroupHeaderBuilder? groupHeaderBuilder;
  final Future<List<T>> Function(String query)? futureRequest;
  final Duration? futureRequestDelay;
  final int searchRequestMinChars;
  final Widget? searchRequestLoadingIndicator;
  final bool canClearSelection;
  final bool enableHapticFeedback;
  final int maxLines;
  final double? overlayHeight;
  final DropdownOverlayDirection overlayDirection;
  final OverlayPortalController? overlayController;
  final ScrollController? itemsScrollController;
  final bool canCloseOutsideBounds;
  final bool hideSelectedFieldWhenExpanded;
  final bool autofocusOnSearch;
  final EdgeInsetsGeometry padding;
  final String? labelText;
  final Widget? label;

  const CustomDropdownMultiSearch({
    super.key,
    required this.items,
    required this.onListChanged,
    this.initialItems,
    this.multiSelectController,
    this.hintText = 'Select options',
    this.searchHintText = 'Search...',
    this.noResultFoundText = 'No result found.',
    this.decoration,
    this.disabledDecoration,
    this.enabled = true,
    this.listValidator,
    this.validateOnChange = true,
    this.listItemBuilder,
    this.headerListBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.groupBy,
    this.groupHeaderBuilder,
    this.canClearSelection = true,
    this.enableHapticFeedback = true,
    this.maxLines = 1,
    this.overlayHeight,
    this.overlayDirection = DropdownOverlayDirection.auto,
    this.overlayController,
    this.itemsScrollController,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.autofocusOnSearch = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0),
    this.labelText,
    this.label,
  })  : futureRequest = null,
        futureRequestDelay = null,
        searchRequestMinChars = 0,
        searchRequestLoadingIndicator = null;

  const CustomDropdownMultiSearch.searchRequest({
    super.key,
    required this.futureRequest,
    required this.onListChanged,
    this.initialItems,
    this.multiSelectController,
    this.futureRequestDelay = const Duration(milliseconds: 300),
    this.searchRequestMinChars = 0,
    this.searchRequestLoadingIndicator,
    this.hintText = 'Select options',
    this.searchHintText = 'Search...',
    this.noResultFoundText = 'No result found.',
    this.decoration,
    this.disabledDecoration,
    this.enabled = true,
    this.listValidator,
    this.validateOnChange = true,
    this.listItemBuilder,
    this.headerListBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.canClearSelection = true,
    this.enableHapticFeedback = true,
    this.maxLines = 1,
    this.overlayHeight,
    this.overlayDirection = DropdownOverlayDirection.auto,
    this.overlayController,
    this.itemsScrollController,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.autofocusOnSearch = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0),
    this.labelText,
    this.label,
  })  : items = null,
        groupBy = null,
        groupHeaderBuilder = null;

  @override
  Widget build(BuildContext context) {
    if (futureRequest != null) {
      return CustomDropdownSearch<T>.multiSelectSearchRequest(
        futureRequest: futureRequest!,
        onListChanged: onListChanged,
        initialItems: initialItems,
        multiSelectController: multiSelectController,
        futureRequestDelay: futureRequestDelay,
        searchRequestMinChars: searchRequestMinChars,
        searchRequestLoadingIndicator: searchRequestLoadingIndicator,
        hintText: hintText,
        searchHintText: searchHintText,
        noResultFoundText: noResultFoundText,
        decoration: decoration,
        disabledDecoration: disabledDecoration,
        enabled: enabled,
        listValidator: listValidator,
        validateOnChange: validateOnChange,
        listItemBuilder: listItemBuilder,
        headerListBuilder: headerListBuilder,
        hintBuilder: hintBuilder,
        noResultFoundBuilder: noResultFoundBuilder,
        canClearSelection: canClearSelection,
        enableHapticFeedback: enableHapticFeedback,
        maxLines: maxLines,
        overlayHeight: overlayHeight,
        overlayDirection: overlayDirection,
        overlayController: overlayController,
        itemsScrollController: itemsScrollController,
        canCloseOutsideBounds: canCloseOutsideBounds,
        hideSelectedFieldWhenExpanded: hideSelectedFieldWhenExpanded,
        autofocusOnSearch: autofocusOnSearch,
        padding: padding,
        labelText: labelText,
        label: label,
      );
    }

    return CustomDropdownSearch<T>.multiSelectSearch(
      items: items ?? [],
      onListChanged: onListChanged,
      initialItems: initialItems,
      multiSelectController: multiSelectController,
      hintText: hintText,
      searchHintText: searchHintText,
      noResultFoundText: noResultFoundText,
      decoration: decoration,
      disabledDecoration: disabledDecoration,
      enabled: enabled,
      listValidator: listValidator,
      validateOnChange: validateOnChange,
      listItemBuilder: listItemBuilder,
      headerListBuilder: headerListBuilder,
      hintBuilder: hintBuilder,
      noResultFoundBuilder: noResultFoundBuilder,
      groupBy: groupBy,
      groupHeaderBuilder: groupHeaderBuilder,
      canClearSelection: canClearSelection,
      enableHapticFeedback: enableHapticFeedback,
      maxLines: maxLines,
      overlayHeight: overlayHeight,
      overlayDirection: overlayDirection,
      overlayController: overlayController,
      itemsScrollController: itemsScrollController,
      canCloseOutsideBounds: canCloseOutsideBounds,
      hideSelectedFieldWhenExpanded: hideSelectedFieldWhenExpanded,
      autofocusOnSearch: autofocusOnSearch,
      padding: padding,
      labelText: labelText,
      label: label,
    );
  }
}
