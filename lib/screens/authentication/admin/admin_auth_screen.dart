import 'package:college_notice/data/module/auth_helper.dart';
import 'package:college_notice/data/module/shared_prefs_helper.dart';
import 'package:college_notice/interface/process_task.dart';
import 'package:college_notice/screens/authentication/admin/college_details_page.dart';
import 'package:college_notice/screens/authentication/admin/verify_admin_page.dart';
import 'package:college_notice/screens/home/admin/admin_home.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/widgets/login_form.dart';
import 'package:college_notice/widgets/registration_form.dart';
import 'package:flutter/material.dart';

class AdminAuthPage extends StatefulWidget {
  const AdminAuthPage({super.key});

  @override
  State<AdminAuthPage> createState() => _AdminAuthPageState();
}

class _AdminAuthPageState extends State<AdminAuthPage> implements ProcessTask {
  late final AuthHelper authHelper = AuthHelper.withAuthStateListener(this);

  VoidCallback? callback;

  int state = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
      ),
      body: Center(
        child: state == 0
        ? LoginForm(
          onLogin: onLogin,
          notRegisteredMessage: "Not registered?",
          registerHereMessage: "Add new college",
          onRegisterherePressed: onRegisterHerePressed,
        )
        : RegistrationForm(
            onLoginHerePressed: onLoginHerePressed,
            onRegister: onRegister,
          ),
      ),
    );
  }

  void onRegisterHerePressed() {
    setState(() {
      state = 1;
    });
  }

  void onLoginHerePressed() {
    setState(() {
      state = 0;
    });
  }

  void onLogin(String email, String password, VoidCallback onComplete) {
    authHelper.login(email, password);
    callback = onComplete;
  }

  void onRegister(String email, String password, VoidCallback onComplete) {
    authHelper.register(email, password);
    callback = onComplete;
  }

  @override
  void onSuccess() {
    SharedPrefsHelper().setUserRole('admin');
    callback?.call();
    switch (state) {
      case 0:
        onLoginSuccess();
        break;
      case 1:
        onRegisterSuccess();
        break;
      default:
        showSnackBar(context, "Wrong state");
    }
  }

  @override
  void onFailed(String? error) {
    callback?.call();
    showSnackBar(context, error ?? "Something went wrong", Colors.red);
  }
  
  void onRegisterSuccess() {
    showSnackBar(context,"Registered successfully", Colors.green);
    goTo(context, VerifyUserPage(onVerify: () => escape(context, const CollegeDetailsPage()),));
  }
  
  void onLoginSuccess() {
    showSnackBar(context, "Login successfully" , Colors.green);
    if (user != null) {
      if(user?.emailVerified ?? false) {
        goToHome();
      } else {
        goTo(context, VerifyUserPage(onVerify: goToHome,));
      }
    } else {
      showSnackBar(context, "User is null", Colors.red);
    }
  }

  void goToHome() {
    escape(context, const AdminHome());
  }
  
}
