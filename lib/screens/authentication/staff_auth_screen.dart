import 'package:college_notice/data/models/colllege.dart';
import 'package:college_notice/data/models/department.dart';
import 'package:college_notice/data/models/staff.dart';
import 'package:college_notice/data/module/auth_helper.dart';
import 'package:college_notice/data/module/firestore_helper.dart';
import 'package:college_notice/data/module/shared_prefs_helper.dart';
import 'package:college_notice/interface/process_task.dart';
import 'package:college_notice/screens/authentication/admin/verify_admin_page.dart';
import 'package:college_notice/screens/home/staff/staff_home_page.dart';
import 'package:college_notice/screens/subjects/staff_subjects.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/widgets/app_dropdown_menu.dart';
import 'package:college_notice/widgets/college_department_selection.dart';
import 'package:college_notice/widgets/login_form.dart';
import 'package:college_notice/widgets/registration_form.dart';
import 'package:flutter/material.dart';

class StaffAuthPage extends StatefulWidget {
  const StaffAuthPage({super.key});

  @override
  State<StaffAuthPage> createState() => _StaffAuthPageState();
}

class _StaffAuthPageState extends State<StaffAuthPage> implements ProcessTask {
  int mode = 0;
  College? college;
  Department? department;
  Staff? staff;

  VoidCallback? callback;

  FirestoreHelper firestoreHelper = FirestoreHelper();
  late AuthHelper authHelper = AuthHelper.withAuthStateListener(this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff"),
      ),
      body: Center(child: buildBody()),
    );
  }

  Widget buildBody() {
    switch (mode) {
      case 0:
        return LoginForm(
          onRegisterherePressed: () => setMode(1),
          onLogin: onLogin,
        );
      case 1:
        return CollegeDepartmnetSelction(
          onNext: onCollegeDepartmentSelect,
        );
      case 2:
        return RegistrationForm(
          // prefix: [
          //   verticalMargin(),
          //   dropDown("Select college", colleges),
          //   verticalMargin(),
          //   dropDown("Select department", departments),
          //   verticalMargin(),
          // ],
          onLoginHerePressed: () => setMode(0),
          onRegister: onRegister,
        );
      default:
        return const SizedBox();
    }
  }

  SizedBox verticalMargin() {
    return const SizedBox(
      height: 24,
    );
  }

  Widget dropDown(
    String hintText,
    List<String> options,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 32,
      child: AppDropdownMenu(
        hintText: hintText,
        options: options,
      ),
    );
  }

  void onLogin(String email, String password, VoidCallback onComplete) {
    authHelper.login(email, password);
    callback = onComplete;
  }

  void onRegister(
      String email, String password, VoidCallback onComplete) async {
    
    if ((staff = await firestoreHelper.checkForStaffExist(
        college!.id, department!.id, email)) != null) {
      authHelper.register(email, password);
      callback = onComplete;
    } else {
      showSnackBar(context, "Your email is not exists in staff of this department", Colors.red);
      onComplete();
    }
    
  }

  void onCollegeDepartmentSelect(College college, Department department) {
    this.college = college;
    this.department = department;
    setMode(2);
  }

  void setMode(int mode) {
    setState(() {
      this.mode = mode;
    });
  }

  @override
  void onSuccess() async {
    debugPrint("Staff auth succuess");
    SharedPrefsHelper().setUserRole("staff").then(
      (_) {
        debugPrint("userrole: ${SharedPrefsHelper().getUserRole()}");
        callback?.call();

          if(user != null && user!.emailVerified) {
            escape(
              context,
              const StaffHome(),
            );
          } else {
            goTo(context, VerifyUserPage(onVerify: goToProfile));
          }
      }
    );
    
  }

  @override
  void onFailed(String? error) {
    callback?.call();
    showSnackBar(context, error ?? "Something went wrong", Colors.red);
  }


  void goToProfile() {
    escape(
        context,
        StaffSubjectPage(
          staff: staff!,
        ),
      );
  }
}
