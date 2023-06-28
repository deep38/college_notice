import 'package:flutter/material.dart';

class TextMarquee extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration? duration;
  final Duration pauseDuration;

  const TextMarquee({Key? key, required this.text, this.style, this.duration, this.pauseDuration = const Duration(seconds: 1)})
      : super(key: key);

  @override
  State<TextMarquee> createState() => _TextMarqueeState();
}

class _TextMarqueeState extends State<TextMarquee> {
  ScrollController scrollController = ScrollController();

  late Duration duration;

  @override
  void initState() {
    super.initState();
    duration = widget.duration ?? Duration(milliseconds: widget.text.length * 10);
    WidgetsBinding.instance.addPostFrameCallback(scroll);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: Text(
        widget.text
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }


  void scroll(_) async {
    while(scrollController.hasClients) {
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients) {
        await scrollController.animateTo(scrollController.position.maxScrollExtent, duration: duration, curve: Curves.ease);
      }
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients) {
        await scrollController.animateTo(0.0, duration: duration, curve: Curves.ease);
      }
    }
  }
}