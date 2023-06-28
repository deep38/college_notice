import 'package:flutter/material.dart';

class ResponsivePage extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget body;

  const ResponsivePage({
    super.key,
    required this.appBar,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: width < height
        ? appBar
        : null,
      body: width < height
        ? body
        : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appBar,
            body,
          ],
        )
    );
  }
}
