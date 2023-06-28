import 'package:flutter/material.dart';

class AppChip extends StatefulWidget {
  final String label;
  final Widget? deleteIcon;
  final Color? deleteIconColor;
  final OutlinedBorder? shape;
  final Function()? onDeleted;

  const AppChip({
    super.key,
    required this.label,
    this.deleteIcon,
    this.deleteIconColor,
    this.shape,
    this.onDeleted,
  });

  @override
  State<AppChip> createState() => _AppChipState();
}

class _AppChipState extends State<AppChip> {
  bool disabled = false;

  @override
  Widget build(BuildContext context) {
    Color disabledColor = Theme.of(context).disabledColor;

    return Chip(
      label: Text(
        widget.label,
        style: disabled
            ? Theme.of(context)
                .chipTheme
                .labelStyle
                ?.copyWith(color: disabledColor)
            : null,
      ),
      deleteIcon: widget.deleteIcon,
      deleteIconColor: disabled ? disabledColor : widget.deleteIconColor,
      shape: widget.shape ?? const StadiumBorder(),
      onDeleted: disabled ? () {} : onDeleted,
      surfaceTintColor: disabled ? disabledColor : null,
      backgroundColor: disabled ? disabledColor : null,
      side: disabled ? BorderSide.none : null,
    );
  }

  void onDeleted() {
    debugPrint("Deleting..");
    setState(() {
      disabled = true;
    });
    widget.onDeleted?.call();
  }
}
