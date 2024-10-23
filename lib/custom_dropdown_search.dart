import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:custom_dropdown_search/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class CustomDropdownSearch<T> extends StatelessWidget {
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String hintText;

  const CustomDropdownSearch({
    Key? key,
    required this.items,
    required this.onChanged,
    this.hintText = 'Select Employee',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: CustomDropdown<T>.search(
        decoration: CustomDropdownDecoration(
          closedFillColor: Provider.of<ThemeProvider>(context).getIsDarkMode
              ? Colors.grey.shade900
              : Colors.white,
          expandedFillColor: Provider.of<ThemeProvider>(context).getIsDarkMode
              ? Colors.grey.shade900
              : Colors.white,
          headerStyle: TextStyle(
              color: Provider.of<ThemeProvider>(context).getIsDarkMode
                  ? Colors.white
                  : Colors.black),
          listItemStyle: TextStyle(
              color: Provider.of<ThemeProvider>(context).getIsDarkMode
                  ? Colors.white
                  : Colors.black),
          hintStyle: TextStyle(
              color: Provider.of<ThemeProvider>(context).getIsDarkMode
                  ? Colors.white
                  : Colors.black),
          noResultFoundStyle: TextStyle(
              color: Provider.of<ThemeProvider>(context).getIsDarkMode
                  ? Colors.white
                  : Colors.black),
        ),
        hintText: hintText,
        items: items,
        onChanged: (value) {
          HapticFeedback.selectionClick();
          onChanged(value);
        },
      ),
    );
  }
}
