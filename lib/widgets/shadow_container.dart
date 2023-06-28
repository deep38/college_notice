import 'dart:math';

import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Widget child;

  const ShadowContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: min(MediaQuery.of(context).size.width, 400),
      padding: const EdgeInsets.symmetric( horizontal: 12.0, vertical: 8,),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: const Offset(1, 1),
            spreadRadius: 1,
            blurRadius: 12,
            color: Theme.of(context).colorScheme.surface,
          )
        ],
      ),
      child: child,
    );
  }
}
