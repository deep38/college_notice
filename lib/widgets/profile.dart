import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String title;

  const Profile({
    super.key,
    this.title = "Profile",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 56,),
            CircleAvatar()
          ],
        ),
      ),
    );
  }
}
