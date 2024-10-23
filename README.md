
## Custom Dropdown Search
A custom dropdown search widget for Flutter, designed to provide a clean and customizable search experience in dropdown lists. It supports dark mode, theming, and customizable items.

## Features

- Customizable dropdown search widget
- Supports dark and light mode theming
- Easy integration with any Flutter app
- Can be used with various item types (Strings, models, etc.)


## Installation

To use the package, first add the following dependency to your `pubspec.yaml`:

    dependencies:
        custom_dropdown_search: ^0.0.1  # Replace with the current version



## Usage
    import 'package:flutter/material.dart';
    import 'package:custom_dropdown_search/custom_dropdown_search.dart';

    void main() {
        runApp(MyApp());
    }

    class MyApp extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
            return MaterialApp(
                title: 'Custom Dropdown Search Demo',
                theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: DropdownSearchExample(),
        );
    }
}

    class DropdownSearchExample extends StatefulWidget {
        @override
        _DropdownSearchExampleState createState() => _DropdownSearchExampleState();
    }

    class _DropdownSearchExampleState extends State<DropdownSearchExample> {
        List<String> employees = [
        "John Doe",
        "Jane Smith",
        "Bob Johnson",
        "Alice White",
        "Charlie Brown",
      ];

      String? selectedEmployee;

      @override
      Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
        title: Text("Custom Dropdown Search Demo"),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomDropdownSearch<String>(
          items: employees,   // List of items
          hintText: "Select Employee",  // Placeholder text
          onChanged: (value) {
            setState(() {
              selectedEmployee = value;  // Handle value changes
            });
          },
        ),
      ),
    );
}
}

## Usage with Custom Objects (Model)
You can also use the dropdown with custom data types like models. Here’s an example using an Employee model:

    import 'package:flutter/material.dart';
    import 'package:custom_dropdown_search/custom_dropdown_search.dart';

    class Employee {
        final String id;
        final String name;

        Employee({required this.id, required this.name});
    }

    void main() {
        runApp(MyApp());
    }

    class MyApp extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
          return MaterialApp(
          title: 'Custom Dropdown Search with Model',
          theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DropdownWithModelExample(),
        );
      }
    }

    class DropdownWithModelExample extends StatefulWidget {
        @override
        _DropdownWithModelExampleState createState() => _DropdownWithModelExampleState();
    }

    class _DropdownWithModelExampleState extends State<DropdownWithModelExample> {
          List<Employee> employees = [
          Employee(id: "1", name: "John Doe"),
          Employee(id: "2", name: "Jane Smith"),
          Employee(id: "3", name: "Bob Johnson"),
          ];

          Employee? selectedEmployee;

          @override
          Widget build(BuildContext context) {
          return Scaffold(
          appBar: AppBar(
          title: Text("Dropdown with Model Example"),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomDropdownSearch<Employee>(
              items: employees,  // List of employee objects
              hintText: "Select Employee",
              onChanged: (value) {
                setState(() {
                  selectedEmployee = value;  // Handle value change
                });
              },
            ),
          ),
        );
      }
    }

## Custom Theming
You can customize the appearance of the dropdown by changing colors, text styles, and more based on the current theme. Here's an example of customizing the dropdown for dark and light modes:

    import 'package:flutter/material.dart';
    import 'package:custom_dropdown_search/custom_dropdown_search.dart';

    class ThemedDropdownSearch extends StatelessWidget {
        final List<String> items = ["Option 1", "Option 2", "Option 3"];

    @override
    Widget build(BuildContext context) {
      bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

      return Scaffold(
        appBar: AppBar(
          title: Text("Custom Themed Dropdown"),
      ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
              child: CustomDropdownSearch<String>(
                items: items,
                hintText: "Select an Option",
                onChanged: (value) {},
                // Custom theme for the dropdown
                decoration: CustomDropdownDecoration(
                closedFillColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
                expandedFillColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
                headerStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                listItemStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                hintStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.grey),
              ),
            ),
          ),
       );
      }
    }

## CustomDropdownDecoration

This class allows you to customize the dropdown's appearance. The available fields include:

closedFillColor: The background color of the dropdown when it's closed.
expandedFillColor: The background color of the dropdown when it's expanded.
headerStyle: The text style for the header.
listItemStyle: The text style for the list items.
hintStyle: The text style for the hint text.
noResultFoundStyle: The text style when no search results are found.
## CustomDropdownDecoration
This class allows you to customize the dropdown's appearance. The available fields include:

- closedFillColor: The background color of the dropdown when it's closed.
- expandedFillColor: The background color of the dropdown when it's expanded.
- headerStyle: The text style for the header.
- listItemStyle: The text style for the list items.
- hintStyle: The text style for the hint text.
- noResultFoundStyle: The text style when no search results are found.


## Example Customization

    CustomDropdownSearch<String>(
        items: ["Option 1", "Option 2", "Option 3"],
        onChanged: (value) => print("Selected: $value"),
        hintText: "Select an Option",
        decoration: CustomDropdownDecoration(
            closedFillColor: Colors.blue,
            expandedFillColor: Colors.lightBlue,
            headerStyle: TextStyle(color: Colors.white),
            listItemStyle: TextStyle(color: Colors.black),
        ),
    )

## License

This package is licensed under the [MIT](https://choosealicense.com/licenses/mit/) License. See the LICENSE file for more information.

