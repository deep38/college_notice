import 'package:college_notice/data/models/notice.dart';
import 'package:college_notice/data/module/fcm_api.dart';
import 'package:college_notice/data/module/firestore_helper.dart';
import 'package:college_notice/data/module/shared_prefs_helper.dart';
import 'package:college_notice/screens/home/students/notice_list_page.dart';
import 'package:college_notice/screens/notice_view_page.dart';
import 'package:college_notice/screens/subjects/student_subjects.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/widgets/reusable_card.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({
    super.key,
  });

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  FirestoreHelper firestoreHelper = FirestoreHelper();
  String? collegeId, departmentId;

  @override
  void initState() {
    super.initState();
    collegeId = sharedPrefsHelper.getCollegeId();
    departmentId = sharedPrefsHelper.getDepartmentId();
    FcmApi.context = context;
    debugPrint("Context initialized: ${FcmApi.context}");
    loadNoticeFromNotification();
  }

  void loadNoticeFromNotification() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        goTo(context, NoticeView(notice: Notice.fromMap(message.data)));
      }
    });
  }

  @override
  void dispose() {
    debugPrint("Student home Disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("FCMApi Context: ${FcmApi.context}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                accountName: buildFromFuture(firestoreHelper.getCollegeNameById(collegeId!)),
                accountEmail: buildFromFuture(firestoreHelper.getDepartmentNameById(departmentId!))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HeaderWithSearchBox(size: size),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                "Explore Categories",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.58,
              margin: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ReusableCard(
                            "Notice",
                            "assets/images/notice.png",
                            onTap: () => goTo(context, const NoticeListPage()),
                          ),
                          ReusableCard("Subjects", "assets/images/syllabus.png",
                              onTap: () =>
                                  goTo(context, const StudentSubjects())),
                        ],
                      ),
                      // Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // children: [
                      //   ReusableCard(
                      //     "Last year paper",
                      //     "assets/images/question.png",
                      //     onTap: openNoticeView,
                      //   ),
                      // ReusableCard(
                      //   "Percentage Calculator",
                      //   "assets/images/percentage.png",
                      //   onTap: () => _goToPage(context, const PercentageScreen()),
                      // ),
                      //   ],
                      // ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildFromFuture(Future<String>? future) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) => Text(
        snapshot.data ?? ".....",
        overflow: TextOverflow.visible,
      ),
    );
  }
}
