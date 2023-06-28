import 'dart:math';

import 'package:flutter/material.dart';

class CircularAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final Color? backgroundColor;

  const CircularAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    double size = min<double>(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return SizedBox(
      height: (size * 2) -
          (size * 1.25),
      width: size,
      child: Stack(children: [
        
        Positioned(
          left: -(size * 0.90),
          top: -(size * 1.25),
          child: Container(
            height: size * 2,
            width: size * 2,
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
                color: backgroundColor ?? Theme.of(context).colorScheme.primary,
                borderRadius:
                    BorderRadius.circular(size)),
          ),
        ),
        if(Navigator.of(context).canPop())
          Positioned(
            top: 32,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white,),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        Positioned(
          top: 120,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(title != null)
              SizedBox(
                width: size * 0.7,
                child: Text(
                  title!,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.start,
                ),
              ),

              if (subtitle != null)
              SizedBox(
                width: size * 0.6,
                child: Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.titleSmall,
                  
                ),
              ),
            ],
          ),
        ),
        
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(300);
}
