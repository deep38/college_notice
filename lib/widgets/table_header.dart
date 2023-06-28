import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  final List<String> columns;

  const TableHeader({
    super.key,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: columns
          .map((name) => Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all()
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold
                ),

              ),
            ),
          ))
          .toList(),
    );
  }
}
