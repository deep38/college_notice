import 'package:college_notice/data/models/staff.dart';
import 'package:college_notice/data/module/firestore_helper.dart';
import 'package:college_notice/screens/authentication/admin/verify_admin_page.dart';
import 'package:college_notice/screens/home/staff/add_new_notice_page.dart';
import 'package:college_notice/screens/home/staff/uploaded_notices_page.dart';
import 'package:college_notice/screens/subjects/staff_subjects.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/widgets/action_button.dart';
import 'package:flutter/material.dart';

class StaffHome extends StatefulWidget {
  const StaffHome({super.key});

  @override
  State<StaffHome> createState() => _StaffHomeState();
}

class _StaffHomeState extends State<StaffHome> {
  FirestoreHelper firestoreHelper = FirestoreHelper();

  Staff? staff;

  @override
  void initState() {
    super.initState();

    if (user!.emailVerified) {
      firestoreHelper.getStaff(user!.email!).then((value) {
        staff = value;
        setState(() {});
      });
    } else {
      escape(context, VerifyUserPage(onVerify: () {
        escape(context, const StaffHome());
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Dashboard"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: staff != null
                  ? FutureBuilder(
                      future: firestoreHelper.getCollegeAndDepartmentNameById(
                          staff!.collegeId, staff!.departmentId),
                      builder: (context, snapshot) =>
                          Text(snapshot.data ?? ".....", overflow: TextOverflow.visible,),
                    )
                  : const Text('.....'),
              accountEmail: Text(user!.email!),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            ActionButton(
                title: "New notice",
                icon: Icons.add,
                onPressed: onNewNoticePressed),
            ActionButton(
              title: "Uploaded notices",
              icon: Icons.history,
              onPressed: () => goTo(context, UploadedNotices(staff: staff!)),
            ),
            ActionButton(
              title: "Subjects",
              icon: Icons.subject,
              onPressed: () {
                goTo(context, StaffSubjectPage(staff: staff!));
              },
            ),
          ],
        ),
      ),
    );
  }

  void onNewNoticePressed() {
    goTo(
        context,
        AddNewNotice(
          staff: staff!,
        ));
  }
}
