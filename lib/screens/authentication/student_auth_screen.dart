import 'package:college_notice/data/models/colllege.dart';
import 'package:college_notice/data/models/department.dart';
import 'package:college_notice/data/module/shared_prefs_helper.dart';
import 'package:college_notice/screens/subjects/student_subjects.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/widgets/college_department_selection.dart';
import 'package:flutter/material.dart';

class StudentAuthPage extends StatefulWidget {
  const StudentAuthPage({super.key});

  @override
  State<StudentAuthPage> createState() => _StudentAuthPageState();
}

class _StudentAuthPageState extends State<StudentAuthPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  final SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();

  int state = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
            child: CollegeDepartmnetSelction(
          onNext: onCollegeDepartmentSelected,
        )),
      ),
    );
  }

  void onCollegeDepartmentSelected(
      College college, Department department) async {
    sharedPrefsHelper.setCollegeId(college.id).then((value) => sharedPrefsHelper
        .setDepartmentId(department.id)
        .then((value) =>
            sharedPrefsHelper.setUserRole('student').then((value) => done())));
    // await ;
    // await ;
  }

  void done() {
    escape(context, const StudentSubjects());
  }
}
