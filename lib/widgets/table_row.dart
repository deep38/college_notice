import 'dart:io';

import 'package:flutter/material.dart';

class AppTableRow extends StatefulWidget {
  final List<String> data;
  const AppTableRow({super.key, required this.data});

  @override
  State<AppTableRow> createState() => _AppTableRowState();
}

class _AppTableRowState extends State<AppTableRow> {
  final FocusNode focusNode = FocusNode();
  bool showOptions = false;

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid || Platform.isIOS
        ? Focus(
            onFocusChange: (focused) {
              setState(() {
                showOptions = focused;
              });
            },

            focusNode: focusNode,
            canRequestFocus: true,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(focusNode);
              },
              child: buildChild(context),
            ),
          )
        : MouseRegion(
            onEnter: (event) {
              setState(() {
                showOptions = true;
              });
            },
            onExit: (event) {
              setState(() {
                showOptions = false;
              });
            },
            child: buildChild(context),
          );
  }

  Stack buildChild(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Row(
          children: widget.data
              .map((name) => Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(border: Border.all()),
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ))
              .toList(),
        ),
        if (showOptions)
          Container(
            height: 32,

            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  // Theme.of(context).colorScheme.primary.withAlpha(100),
                  Colors.transparent,
                ]
              )
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buidActionButton(Icons.edit, "Edit", (){}),
                buidActionButton(Icons.delete, "Delete", () { }),
                
              ],
            ),
          )
      ],
    );
  }

  IconButton buidActionButton(IconData icon, String tooltip, VoidCallback onPressed) {
    return IconButton(
      // splashRadius: 1,
      padding: EdgeInsets.zero,
      tooltip: tooltip,
      // constraints: BoxConstraints.tight(Size(24,24)),
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 22,
        color: Colors.white,
      ),
    );
  }
}
