import 'package:college_notice/data/models/colllege.dart';
import 'package:college_notice/data/models/department.dart';
import 'package:college_notice/data/module/auth_helper.dart';
import 'package:college_notice/data/module/firestore_helper.dart';
import 'package:college_notice/data/module/shared_prefs_helper.dart';
import 'package:college_notice/interface/process_task.dart';
import 'package:college_notice/screens/authentication/admin/verify_admin_page.dart';
import 'package:college_notice/screens/home/admin/admin_department_managment_page.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/widgets/college_department_selection.dart';
import 'package:college_notice/widgets/login_form.dart';
import 'package:college_notice/widgets/registration_form.dart';
import 'package:flutter/material.dart';

class DepartmentAdminAuth extends StatefulWidget {
  const DepartmentAdminAuth({super.key});

  @override
  State<DepartmentAdminAuth> createState() => _DepartmentAdminAuthState();
}

class _DepartmentAdminAuthState extends State<DepartmentAdminAuth> implements ProcessTask {
  int mode = 0;
  FirestoreHelper firestoreHelper = FirestoreHelper();
  late AuthHelper authHelper = AuthHelper.withAuthStateListener(this);

  College? college;
  Department? department;

  VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Department Admin"),
      ),
      body: Center(
        child: buildBody(),
      )
    );
  }

  Widget buildBody() {
    switch (mode) {
      case 0:
        return LoginForm(
                onRegisterherePressed: () => setMode(1),
                onLogin: onLoign,
              );
      case 1: 
        return CollegeDepartmnetSelction(onNext: onCollegeDepartmentSelect,);
      case 2:      
        return RegistrationForm(
                onLoginHerePressed: () => setMode(0),
                onRegister: onRegister,
              );
      default:
        return const SizedBox();
    }
  }

  void setMode(int mode) {
    setState(() {
      this.mode = mode;
    });
  }

  void onCollegeDepartmentSelect(College college, Department department) {
    this.college = college;
    this.department = department;
    setMode(2);
  }



  void onLoign(String email, String password, VoidCallback onComplete) {
    authHelper.login(email, password);
    callback = onComplete;
  }

  void onRegister(String email, String password, VoidCallback onComplete) async {
    if(college != null && department != null && await firestoreHelper.checkForAdminExist(college!.id, department!.id, email)) {
      authHelper.register(email, password);
    } else {
      showSnackBar(context, "Your email is not matched with admin of this department", Colors.red);
      onComplete();
    }
  }


  @override
  void onSuccess() async {
    callback?.call();
    SharedPrefsHelper().setUserRole("depadmin");
    if (user != null && user!.emailVerified) {
      goToHome();
    } else {
      goTo(context, VerifyUserPage(onVerify: goToHome,));
    }
  }


  @override
  void onFailed(String? error) {
    showSnackBar(context, "Error: $error", Colors.red);
    callback?.call();
  }

  void goToHome() {
    escape(context, const DepartmentManagment());
  }
}
