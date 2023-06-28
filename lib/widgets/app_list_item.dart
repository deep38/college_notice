import 'package:flutter/material.dart';

class AppListItem extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final VoidCallback? onPressed;

  const AppListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onPressed,
    this.enabled = true,
  });

  @override
  State<AppListItem> createState() => _DepartmentListItemState();
}

class _DepartmentListItemState extends State<AppListItem> {
  final double shrinkSizeFactor = 0.9;

  bool pressed = false;
  
  @override
  Widget build(BuildContext context) {
    
    const double height = 120;

    return GestureDetector(
      onTapDown: (details) => setState(() {
        pressed = true;
      }),
      onTapUp: (details) => setState(() {
        pressed = false;
      }),
      onTapCancel: () => setState(() {
        pressed = false;
      }),

      onTap: widget.enabled ? widget.onPressed : null,

      child: SizedBox(
        height: height,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          height: height,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(16),
          margin: EdgeInsets.all(pressed ? 10 : 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              width: 1,
              color: widget.enabled
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).disabledColor
            )
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(widget.leading != null)
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 98,
                    maxWidth: 98,
                  ),
                  margin: const EdgeInsets.only(right: 24),
                  child: widget.leading!
                ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: widget.enabled
                        ? Theme.of(context).textTheme.titleMedium
                        : Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).disabledColor
                        ),
                    ),
                    if(widget.subtitle != null)
                    Text(
                      widget.subtitle!,
                      style: widget.enabled
                        ? Theme.of(context).textTheme.bodySmall
                        : Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).disabledColor
                        ),
                    ),
                  ]
                ),
              ),
              IconTheme(
                data: IconThemeData(
                 color: !widget.enabled ? Theme.of(context).disabledColor : null,
                ),
                child: widget.trailing ?? const Icon(
                   Icons.arrow_forward_ios_rounded,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
