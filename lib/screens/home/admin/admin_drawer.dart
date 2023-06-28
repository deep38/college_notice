import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  final String name;
  final String email;

  const AdminDrawer({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(name),
          accountEmail: Text(email),
        ),
        
      ],
    );
  }
}
