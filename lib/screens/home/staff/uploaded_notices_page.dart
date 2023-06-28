import 'package:college_notice/data/models/staff.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/widgets/notice_list_stream_widget.dart';
import 'package:flutter/material.dart';

class UploadedNotices extends StatefulWidget {
  final Staff staff;
  const UploadedNotices({super.key, required this.staff});

  @override
  State<UploadedNotices> createState() => _UploadedNoticesState();
}

class _UploadedNoticesState extends State<UploadedNotices> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: widget.staff.subjects.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uploaded notices"),
        bottom: TabBar(
                isScrollable: true,
                controller: tabController,
                tabs: widget.staff.subjects
                    .map(
                      (subject) => Tab(
                        text: subject,
                      ),
                    )
                    .toList(),
              ),
      ),
      body: TabBarView(
            controller: tabController,
            children: widget.staff.subjects.map((subject) => NoticeListStream(subject: generateTopicName(widget.staff.collegeId, widget.staff.departmentId, subject), showDeleteNotice: true,)).toList()
          )
    );
  }
}