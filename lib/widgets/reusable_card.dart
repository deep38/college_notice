import 'package:flutter/material.dart';

class ReusableCard extends StatefulWidget {
  const ReusableCard(
    this.textInfo,
    this.imgPath, {
    super.key, required this.onTap,
  });
  final String textInfo;
  final String imgPath;
  final  VoidCallback onTap;

  @override
  State<ReusableCard> createState() => _ReusableCardState();
}

class _ReusableCardState extends State<ReusableCard> {
  bool isTaped = false;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double widthFactor = isTaped ? 0.39 : 0.40;
    double heightFactor = isTaped ? 0.25 : 0.26;

    return GestureDetector(
      onTapDown: (details) => setState(() => isTaped = true),
      onTapUp: (details) => setState(() => isTaped = false),
      onTapCancel: () => setState(() => isTaped = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: size.width * widthFactor,
        height: size.height * heightFactor,
        margin: const EdgeInsets.only(top: 15.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 10),
              blurRadius: 50,
              color: Theme.of(context).primaryColor.withOpacity(0.30),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.imgPath),
              radius: 30.0,
            ),
            Text(widget.textInfo,
            textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}