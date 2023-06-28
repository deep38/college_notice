
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String? title;
  final IconData icon;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            offset: Offset(1,1)
          )
        ],
      ),

      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 7, child: FittedBox(child: Icon(icon,))),
              if(title != null) Expanded(flex: 2, child: Text(title ?? "")),
            ],
          ),
        ),
      ),
    );
  }
}