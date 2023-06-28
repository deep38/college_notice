import 'package:college_notice/data/models/notice.dart';
import 'package:college_notice/data/module/firestore_helper.dart';
import 'package:college_notice/data/module/shared_prefs_helper.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/widgets/notice_list.dart';
import 'package:college_notice/widgets/notice_list_stream_widget.dart';
import 'package:flutter/material.dart';

class NoticeListPage extends StatefulWidget {
  const NoticeListPage({super.key});

  @override
  State<NoticeListPage> createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  FirestoreHelper firestoreHelper = FirestoreHelper();
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();

  List<String>? subjects;
  String? previousSubject;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    String? collegeId = sharedPrefsHelper.getCollegeId();
    String? departmentId = sharedPrefsHelper.getDepartmentId();
    subjects = sharedPrefsHelper
        .getSubscribedSubjects()
        .map((e) => generateTopicName(collegeId!, departmentId!, e))
        .toList();
    debugPrint("Init subjects $subjects");
    tabController = TabController(
        initialIndex: currentTab, length: subjects!.length, vsync: this);
    debugPrint("Init tabcontroller length ${tabController.length}");

    tabController.addListener(onTabChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notice Board"),
        bottom: subjects != null
            ? TabBar(
                isScrollable: true,
                controller: tabController,
                tabs: subjects!
                    .map(
                      (subject) => Tab(
                        text: subject.split('-').last,
                      ),
                    )
                    .toList(),
              )
            : null,
      ),
      body: subjects != null
          ? TabBarView(
            controller: tabController,
            children: subjects!.map((subject) => NoticeListStream(subject: subject)).toList()
          )
          : const Center(
              child: Text("No subjects selected"),
            ),
    );
  }

  Widget buildNoticeList(List<Notice> notices) {
    List<String> subjects = [];
    List<List<Notice>> ntoicesAcSub = [];

    for (var notice in notices) {
      String subject = notice.subject.split('-').last;

      if (subjects.contains(subject)) {
        int subjectIndex = subjects.indexOf(subject);
        ntoicesAcSub[subjectIndex].add(notice);
      } else {
        subjects.add(subject);
        ntoicesAcSub.add([notice]);
      }
    }

    debugPrint("Tab: $currentTab");
    tabController.index = currentTab;

    return Column(
      children: [
        TabBar(
          isScrollable: true,
          controller: tabController,
          tabs: subjects
              .map((subject) => Tab(
                    text: subject,
                  ))
              .toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: ntoicesAcSub
                .map((noticeList) => NoticeList(noticeList: noticeList))
                .toList(),
          ),
        ),
      ],
    );
  }

  void onTabChange() {
    currentTab = tabController.index;
    debugPrint("Tab: $currentTab");
  }
}
