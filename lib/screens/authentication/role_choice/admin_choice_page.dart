import 'package:college_notice/res/assets.dart';
import 'package:college_notice/screens/authentication/admin/admin_auth_screen.dart';
import 'package:college_notice/screens/authentication/department_admin_auth_page.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/widgets/role_button.dart';
import 'package:flutter/material.dart';

class AdminChoice extends StatelessWidget {
  const AdminChoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin of"),
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoleButton(color: Colors.red, text: "College", icon: Assets.roleAdmin, onPressed: () => goTo(context, AdminAuthPage())),
            RoleButton(color: Colors.lightBlue, text: "Department", icon: Assets.roleAdmin, onPressed: () => goTo(context, DepartmentAdminAuth())),
          ],
        ),
      ),
    );
  }
}