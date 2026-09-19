# Custom Dropdown List with Search

[![pub package](https://img.shields.io/pub/v/customedropdownlistwithsearch.svg?logo=dart)](https://pub.dev/packages/customedropdownlistwithsearch)
[![pub points](https://img.shields.io/pub/points/customedropdownlistwithsearch?color=2E8B57&label=pub%20points)](https://pub.dev/packages/customedropdownlistwithsearch/score)
[![license](https://img.shields.io/github/license/Earbaj/custom-dropdown-with-search)](https://github.com/Earbaj/custom-dropdown-with-search/blob/master/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/Earbaj/custom-dropdown-with-search?style=social)](https://github.com/Earbaj/custom-dropdown-with-search)

A feature-packed, lightweight, and customizable searchable dropdown package for Flutter. Supports single and multi-selection, async/remote API search with debouncing, infinite pagination, custom item builders, form validation, grouped categories, clear buttons, keyboard navigation, and automatic dark/light theme adaptation without requiring any external state management provider.

---

## ✨ Features

- 🔍 **Searchable Dropdown**: Fast, real-time client-side search filtering.
- 👥 **Multi-Select Support**: Select multiple items with headers, tags, and custom list builders.
- 🌐 **Async / Remote Search**: Search from remote APIs with built-in debouncing and custom loading indicators.
- 📜 **Infinite Scrolling / Pagination**: Lazy-load large datasets on-demand as the user scrolls.
- 🎨 **Custom Item & Header Builders**: Complete control over how items and headers look (avatars, icons, badges, subtitles).
- 🧹 **Clear / Reset Button**: One-tap clear selection button.
- 🛡️ **Form Validation**: Native `validator` and `listValidator` integration with Flutter `Form` and `FormField`.
- 📁 **Grouped / Categorized Dropdown**: Organize items into sections with custom category headers.
- 🌓 **Automatic Dark / Light Theming**: Seamlessly adapts to system or app theme with zero setup and no `ProviderNotFoundException`.
- ⌨️ **Keyboard Navigation & Desktop / Web**: Optimized for mobile, web, and desktop.
- ⚡ **High Performance**: Built with virtualized `ListView.builder` for rendering thousands of items smoothly.

---

## 📦 Installation

Add `customedropdownlistwithsearch` to your `pubspec.yaml`:

```yaml
dependencies:
  customedropdownlistwithsearch: ^1.1.0
```

Then run:

```bash
flutter pub get
```

Import it in your Dart file:

```dart
import 'package:customedropdownlistwithsearch/customedropdownlistwithsearch.dart';
```

---

## 🚀 Usage Examples

### 1. Basic Single Select

```dart
import 'package:flutter/material.dart';
import 'package:customedropdownlistwithsearch/customedropdownlistwithsearch.dart';

class SingleSelectExample extends StatefulWidget {
  const SingleSelectExample({super.key});

  @override
  State<SingleSelectExample> createState() => _SingleSelectExampleState();
}

class _SingleSelectExampleState extends State<SingleSelectExample> {
  final List<String> fruits = ['Apple', 'Banana', 'Orange', 'Mango', 'Pineapple'];
  String? selectedFruit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Single Select Dropdown')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomDropdownSearch<String>(
          items: fruits,
          hintText: 'Select a fruit',
          onChanged: (value) {
            setState(() {
              selectedFruit = value;
            });
          },
        ),
      ),
    );
  }
}
```

---

### 2. Multi-Select Dropdown

Select multiple items effortlessly using either `CustomDropdownSearch.multiSelectSearch` or `CustomDropdownMultiSearch`:

```dart
CustomDropdownSearch<String>.multiSelectSearch(
  items: const ['Flutter', 'Dart', 'React Native', 'Kotlin', 'Swift'],
  hintText: 'Select programming skills',
  onListChanged: (selectedList) {
    print('Selected: $selectedList');
  },
)
```

---

### 3. Async / Remote Search (API with Debounce)

Fetch search results dynamically from your backend API:

```dart
CustomDropdownSearch<String>.searchRequest(
  futureRequest: (query) async {
    // Call your API with debounce (default 300ms)
    await Future.delayed(const Duration(milliseconds: 500));
    final allUsers = ['Alice', 'Bob', 'Charlie', 'David', 'Emma'];
    return allUsers
        .where((user) => user.toLowerCase().contains(query.toLowerCase()))
        .toList();
  },
  futureRequestDelay: const Duration(milliseconds: 300),
  hintText: 'Search users from API...',
  onChanged: (selectedUser) {
    print('Selected user: $selectedUser');
  },
)
```

---

### 4. Custom Object Model with Custom Builders

Customize list items and header with avatars, subtitles, and icons:

```dart
class User {
  final String id;
  final String name;
  final String role;

  const User({required this.id, required this.name, required this.role});

  @override
  String toString() => name;
}

// Widget implementation:
CustomDropdownSearch<User>(
  items: const [
    User(id: '1', name: 'John Doe', role: 'Developer'),
    User(id: '2', name: 'Sarah Connor', role: 'Product Manager'),
    User(id: '3', name: 'Michael Scott', role: 'Regional Manager'),
  ],
  hintText: 'Select team member',
  headerBuilder: (context, user, enabled) {
    return Row(
      children: [
        CircleAvatar(radius: 12, child: Text(user.name[0])),
        const SizedBox(width: 8),
        Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  },
  listItemBuilder: (context, user, isSelected, onItemSelect) {
    return ListTile(
      leading: CircleAvatar(child: Text(user.name[0])),
      title: Text(user.name),
      subtitle: Text(user.role),
      selected: isSelected,
      onTap: onItemSelect,
    );
  },
  onChanged: (user) {
    print('Selected: ${user?.name}');
  },
)
```

---

### 5. Form Validation

Integrates directly with Flutter's `Form` and `FormState`:

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      CustomDropdownSearch<String>(
        items: const ['HR', 'Engineering', 'Marketing', 'Finance'],
        hintText: 'Select Department',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a department';
          }
          return null;
        },
        onChanged: (val) {},
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Form is valid!
          }
        },
        child: const Text('Submit'),
      ),
    ],
  ),
)
```

---

### 6. Grouped / Categorized Items

Group items by category with styled headers:

```dart
final items = [
  {'name': 'Laptop', 'category': 'Electronics'},
  {'name': 'Headphones', 'category': 'Electronics'},
  {'name': 'Desk Chair', 'category': 'Furniture'},
  {'name': 'Standing Desk', 'category': 'Furniture'},
];

CustomDropdownSearch<Map<String, String>>(
  items: items,
  groupBy: (item) => item['category']!,
  headerBuilder: (context, item, _) => Text(item['name']!),
  listItemBuilder: (context, item, isSelected, onItemSelect) {
    return ListTile(
      title: Text(item['name']!),
      onTap: onItemSelect,
    );
  },
  onChanged: (item) {},
)
```

---

### 7. Controllers & Clear Button

Programmatically control or clear selection:

```dart
final controller = SingleSelectController<String?>('Option 1');

// Clear selection:
controller.clear();

// Select new value:
controller.select('Option 2');

// In widget:
CustomDropdownSearch<String>(
  items: const ['Option 1', 'Option 2', 'Option 3'],
  controller: controller,
  canClearSelection: true, // Displays clear (X) button
  onChanged: (val) {},
)
```

---

### 8. Custom Theming & Dark Mode

The dropdown automatically detects light and dark mode from `Theme.of(context)`. You can also customize colors and styles using `CustomDropdownDecoration`:

```dart
CustomDropdownSearch<String>(
  items: const ['Dark Item 1', 'Dark Item 2'],
  hintText: 'Custom styled dropdown',
  onChanged: (val) {},
  decoration: CustomDropdownDecoration(
    closedFillColor: Colors.blueGrey.shade900,
    expandedFillColor: Colors.blueGrey.shade800,
    closedBorder: Border.all(color: Colors.blueAccent),
    closedBorderRadius: BorderRadius.circular(16),
    headerStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    listItemStyle: const TextStyle(color: Colors.white70),
    hintStyle: const TextStyle(color: Colors.grey),
    searchFieldDecoration: SearchFieldDecoration(
      fillColor: Colors.blueGrey.shade700,
      textStyle: const TextStyle(color: Colors.white),
      hintStyle: const TextStyle(color: Colors.white54),
      prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
    ),
  ),
)
```

---

## 🛠️ API Reference

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `items` | `List<T>?` | List of items to display in the dropdown. |
| `onChanged` | `ValueChanged<T?>?` | Callback when selection changes in single-select mode. |
| `onListChanged` | `ValueChanged<List<T>>?` | Callback when selection changes in multi-select mode. |
| `initialItem` | `T?` | Pre-selected item for single-selection. |
| `initialItems` | `List<T>?` | Pre-selected items for multi-selection. |
| `hintText` | `String` | Placeholder text when no item is selected. |
| `searchHintText` | `String` | Placeholder text for the search input field. |
| `noResultFoundText` | `String` | Text shown when no search match is found. |
| `validator` | `FormFieldValidator<T>?` | Form field validator for single selection. |
| `listValidator` | `FormFieldValidator<List<T>>?` | Form field validator for multi-selection. |
| `validateOnChange` | `bool` | Whether to validate immediately when selection changes. |
| `futureRequest` | `Future<List<T>> Function(String)?` | Async callback to fetch items from remote API based on query. |
| `futureRequestDelay` | `Duration?` | Debounce duration for async search (default 300ms). |
| `searchRequestLoadingIndicator` | `Widget?` | Custom loader displayed while fetching async data. |
| `paginatedRequest` | `PaginatedSearchRequest<T>?` | Callback for infinite scroll / pagination loading. |
| `listItemBuilder` | `DropdownListItemBuilder<T>?` | Custom builder for each dropdown list item. |
| `headerBuilder` | `DropdownHeaderBuilder<T>?` | Custom builder for closed single-select header. |
| `headerListBuilder` | `DropdownHeaderListBuilder<T>?` | Custom builder for closed multi-select header. |
| `groupBy` | `String Function(T item)?` | Function returning category name for grouping items. |
| `groupHeaderBuilder` | `DropdownGroupHeaderBuilder?` | Custom builder for category section headers. |
| `canClearSelection` | `bool` | Whether to display a clear (X) button on selected items. |
| `controller` | `SingleSelectController<T?>?` | State controller for single selection. |
| `multiSelectController` | `MultiSelectController<T>?` | State controller for multi selection. |
| `decoration` | `CustomDropdownDecoration?` | Styling options for colors, borders, and text styles. |
| `overlayDirection` | `DropdownOverlayDirection` | Direction to open overlay (`auto`, `below`, `above`). |
| `enableHapticFeedback` | `bool` | Triggers subtle haptic feedback on item selection (default `true`). |

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
