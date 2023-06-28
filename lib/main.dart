import 'package:college_notice/data/module/fcm_api.dart';
import 'package:college_notice/data/module/shared_prefs_helper.dart';
import 'package:college_notice/res/theme.dart';
import 'package:college_notice/screens/authentication/role_choice/role_screen.dart';
import 'package:college_notice/screens/home/admin/admin_department_managment_page.dart';
import 'package:college_notice/screens/home/admin/admin_home.dart';
import 'package:college_notice/screens/home/staff/staff_home_page.dart';
import 'package:college_notice/screens/home/students/student_home_page.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefsHelper.init();
  await FcmApi().init();
  user = FirebaseAuth.instance.currentUser;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  collegeId = sharedPrefsHelper.getCollegeId();
  departmentId = sharedPrefsHelper.getDepartmentId();
  userRole = sharedPrefsHelper.getUserRole();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: AppThemeData.light(),
      routes: {
        Routes.role : (context) => const RolePage(),
        Routes.adminHome :(context) => const AdminHome(),
        Routes.depAdminHome :(context) => const DepartmentManagment(),
        Routes.staffHome :(context) => const StaffHome(),
        Routes.studentHome :(context) => const StudentHome(),
      },
      initialRoute: getRoute(),
      // home: const RolePage(),
    );
  }

  String getRoute() {
    switch(userRole) {
      case 'admin':
        return Routes.adminHome;
      case 'depadmin':
        return Routes.depAdminHome;
      case 'staff':
        return Routes.staffHome;
      case 'student':
        return Routes.studentHome;
      default:
        return Routes.role;
    }
  }
}