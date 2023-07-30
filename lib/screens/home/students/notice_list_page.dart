import 'package:college_notice/data/models/notice.dart';
import 'package:college_notice/data/module/firestore_helper.dart';
import 'package:college_notice/data/module/shared_prefs_helper.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/widgets/notice_list.dart';
import 'package:college_notice/widgets/notice_list_stream_widget.dart';
import 'package:flutter/material.dart';

// enum _NoticeViewMode { subjectVise, dateVise }

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

  late bool _subjectVise;

  List<String>? subjects;
  String? previousSubject;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    String? collegeId = sharedPrefsHelper.getCollegeId();
    String? departmentId = sharedPrefsHelper.getDepartmentId();

    _subjectVise = true;

    subjects = sharedPrefsHelper
        .getSubscribedSubjects()
        .map((e) => generateTopicName(collegeId!, departmentId!, e))
        .toList();

    tabController = TabController(
      initialIndex: currentTab,
      length: subjects!.length,
      vsync: this,
    );

    tabController.addListener(onTabChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notice Board"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _subjectVise = !_subjectVise;
              });
            },
            icon: Icon(
              _subjectVise
              ? Icons.date_range_rounded
              : Icons.subject_rounded
            ),
          )
        ],
        bottom: subjects != null
            ? _subjectVise
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
                : null
            : null,
      ),
      body: subjects != null
          ? _subjectVise
              ? TabBarView(
                  controller: tabController,
                  children: subjects!
                      .map((subject) => NoticeListStream(subject: subject))
                      .toList(),
                )
              : _buildDateVise()
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

  Widget _buildDateVise() {
    final noticeListStream =
        FirestoreHelper().getNoticeStreamForAllSubject(subjects!);
    return StreamBuilder(
      stream: noticeListStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildMessage(snapshot.error?.toString() ?? "Unknown error", Colors.red);
        }

        if(snapshot.hasData) {
          final noticeList = snapshot.data!.docs
              .map((e) => Notice.fromFirebaseMap(e.id, e.data()))
              .toList();
          return noticeList.isNotEmpty
            ? NoticeList(
              // key: Key(genereateRandomKey(10)),
              noticeList: noticeList,
            )
            : _buildMessage("No notice for you");
        }

        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }

  Widget _buildMessage(String message, [Color color = Colors.black]) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: color,
        ),
      ),
    );
  }

  void onTabChange() {
    currentTab = tabController.index;
    debugPrint("Tab: $currentTab");
  }
}
