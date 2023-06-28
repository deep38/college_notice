import 'package:college_notice/res/assets.dart';
import 'package:college_notice/screens/authentication/role_choice/admin_choice_page.dart';
import 'package:college_notice/screens/authentication/staff_auth_screen.dart';
import 'package:college_notice/screens/authentication/student_auth_screen.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/widgets/role_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RolePage extends StatelessWidget {
  const RolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select your role"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoleButton(
                text: "Admin",
                color: Colors.red,
                icon: Assets.roleAdmin,
                iconScale: 1.4,
                onPressed: () => goTo(context, const AdminChoice()),
              ),
              RoleButton(
                text: "Staff",
                color: Colors.blue,
                icon: Assets.roleStaff,
                iconScale: 1.5,
                onPressed: () => goTo(context, const StaffAuthPage()),
              ),
              RoleButton(
                text: "Student",
                color: Colors.green,
                icon: Assets.roleStudent,
                iconScale: 1.8,
                onPressed: () => goTo(context, const StudentAuthPage()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
