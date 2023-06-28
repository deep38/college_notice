import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String? userRole;
User? user;
String? collegeId;
String? departmentId;

// Map<String, String> userAdmin = {};
// Map<String, String> userFaculty = {};
// Map<String, String> userDepartmentAdmin = {};
// Map<String, List<String>> subjectCollection = {};
// Map<String, List<String>>
// Map<String, List<Department>> collegeCollection = {};

List<String> facultyEmails = [];
List<String> facultySubjects = [];


void showSnackBar(BuildContext context, String message, [Color? backgroundColor]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    )
  );
}

String getMonthName(int month) {
  return ["January", "February", "March", "April", "May", "June", "July",
          "August", "September", "October", "November", "December"][month - 1];
}

void goTo(BuildContext context, Widget page) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
}

void escapeTo(BuildContext context, Widget page, String route) {
  Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => page), ModalRoute.withName(route));
}

void escape(BuildContext context, Widget page) {
  Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => page), (route) => false);
}

void goToName(BuildContext context, String route) {
  Navigator.pushNamed(context, route);
}

String generateTopicName(String collegeId, String departmentId, String subject) {
  subject = subject.replaceAll(RegExp(r' '), "_");
  return "$collegeId-$departmentId-$subject";
}

void showSaveAlert(BuildContext context, VoidCallback onSave, VoidCallback onExit) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Save"),
            content: const Text("Do you want to save subjects ?"),
            actions: [
              TextButton(
                  onPressed: onSave,
                  child: const Text("Save")),
              TextButton(
                onPressed: onExit,
                child: const Text("Exit"),
              ),
            ],
          );
        });
  }

void showProgressDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => const FractionallySizedBox(
        widthFactor: 0.5,
        child: AlertDialog(
          content: SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
}