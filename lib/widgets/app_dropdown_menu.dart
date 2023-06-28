
import 'package:flutter/material.dart';

class AppDropdownMenu extends StatelessWidget {
  final String hintText;
  final List options;

  const AppDropdownMenu({
    super.key,
    required this.hintText,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      hintText: hintText,
      enableSearch: true,
      requestFocusOnTap: true,
      
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(
          
          minWidth: MediaQuery.of(context).size.width - 40,
        )
      ),
      dropdownMenuEntries: options
          .map(
            (option) => DropdownMenuEntry<String>(
              value: option,
              label: option,
            ),
          )
          .toList(),
    );
  }
}