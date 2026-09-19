import 'package:customedropdownlistwithsearch/customedropdownlistwithsearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomDropdownSearch Tests', () {
    testWidgets('renders single search dropdown and displays hintText',
        (WidgetTester tester) async {
      String? selected;
      final items = ['Apple', 'Banana', 'Orange'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDropdownSearch<String>(
              items: items,
              hintText: 'Select a fruit',
              onChanged: (val) {
                selected = val;
              },
            ),
          ),
        ),
      );

      expect(find.text('Select a fruit'), findsOneWidget);
      expect(selected, isNull);
    });

    testWidgets('works standalone without Provider in Light and Dark mode',
        (WidgetTester tester) async {
      // Verifies that no ProviderNotFoundException is thrown
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          home: Scaffold(
            body: CustomDropdownSearch<String>(
              items: const ['One', 'Two', 'Three'],
              hintText: 'Dark theme test',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Dark theme test'), findsOneWidget);
    });

    testWidgets('renders multi-select search dropdown and initialItems',
        (WidgetTester tester) async {
      List<String> selectedItems = [];
      final items = ['Flutter', 'Dart', 'React', 'Kotlin'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDropdownSearch<String>.multiSelectSearch(
              items: items,
              initialItems: const ['Flutter'],
              hintText: 'Select languages',
              onListChanged: (val) {
                selectedItems = val;
              },
            ),
          ),
        ),
      );

      expect(find.text('Flutter'), findsOneWidget);
      expect(selectedItems, isEmpty);
    });

    testWidgets('CustomDropdownMultiSearch convenience widget renders properly',
        (WidgetTester tester) async {
      final items = ['Option A', 'Option B'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDropdownMultiSearch<String>(
              items: items,
              hintText: 'Multi search',
              onListChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Multi search'), findsOneWidget);
    });

    testWidgets('renders with custom item builder and header builder',
        (WidgetTester tester) async {
      final items = ['User 1', 'User 2'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDropdownSearch<String>(
              items: items,
              initialItem: 'User 1',
              headerBuilder: (context, selectedItem, enabled) {
                return Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 8),
                    Text(selectedItem),
                  ],
                );
              },
              listItemBuilder: (context, item, isSelected, onItemSelect) {
                return ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: Text(item),
                  selected: isSelected,
                  onTap: onItemSelect,
                );
              },
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.text('User 1'), findsOneWidget);
    });

    testWidgets('supports form validation with FormField validator',
        (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      String? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomDropdownSearch<String>(
                    items: const ['Item 1', 'Item 2'],
                    hintText: 'Choose',
                    validator: (val) {
                      if (val == null) return 'Value is required';
                      return null;
                    },
                    onChanged: (val) => selected = val,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState!.validate();
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Value is required'), findsNothing);

      // Trigger validation
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Value is required'), findsOneWidget);
      expect(selected, isNull);
    });

    testWidgets('renders grouped items properly with category headers',
        (WidgetTester tester) async {
      final employees = [
        {'name': 'Alice', 'dept': 'Engineering'},
        {'name': 'Bob', 'dept': 'Engineering'},
        {'name': 'Charlie', 'dept': 'Sales'},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDropdownSearch<Map<String, String>>(
              items: employees,
              groupBy: (item) => item['dept']!,
              hintText: 'Select team member',
              headerBuilder: (context, item, _) => Text(item['name']!),
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Select team member'), findsOneWidget);
    });

    testWidgets('supports SingleSelectController for clearing and setting value',
        (WidgetTester tester) async {
      final controller = SingleSelectController<String?>('Option 1');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDropdownSearch<String>(
              items: const ['Option 1', 'Option 2'],
              controller: controller,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Option 1'), findsOneWidget);

      controller.clear();
      await tester.pumpAndSettle();

      expect(controller.value, isNull);
    });

    testWidgets('supports async search request constructor',
        (WidgetTester tester) async {
      Future<List<String>> fetchRemoteData(String query) async {
        return ['Result 1', 'Result 2'];
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDropdownSearch<String>.searchRequest(
              futureRequest: fetchRemoteData,
              hintText: 'Search remote API...',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Search remote API...'), findsOneWidget);
    });
  });
}
