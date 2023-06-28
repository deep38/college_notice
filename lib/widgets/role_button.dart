import 'package:flutter/material.dart';

class RoleButton extends StatelessWidget {
  final Color color;
  final String text;
  final Color? textColor;
  final String icon;
  final double iconScale;
  final VoidCallback onPressed;

  const RoleButton({
    super.key,
    required this.color,
    required this.text,
    this.textColor,
    required this.icon,
    this.iconScale = 1.3,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            height: 100,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: <Color>[
                  color,
                  color.withAlpha(150),
                  color.withAlpha(50),
                  Colors.transparent,
                  // Color.fromARGB(159, 244, 67, 54),
                  // Color.fromARGB(55, 244, 67, 54),
                  // Color.fromARGB(0, 255, 255, 255)
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                text,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: textColor ?? Theme.of(context).canvasColor,
                    ),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(30, 0),
            child: Image.asset(
              icon,
              scale: iconScale,
            ),
          ),
        ],
      ),
    );
  }
}