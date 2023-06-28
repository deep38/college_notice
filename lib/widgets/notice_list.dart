import 'package:college_notice/data/models/notice.dart';
import 'package:college_notice/data/module/firestore_helper.dart';
import 'package:college_notice/widgets/notice_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoticeList extends StatefulWidget {
  final List<Notice> noticeList;
  final bool showDeleteNotice;

  const NoticeList({super.key, required this.noticeList, this.showDeleteNotice = false});

  @override
  State<NoticeList> createState() => _NoticeListState();
}

class _NoticeListState extends State<NoticeList> {
  final FirestoreHelper firestoreHelper = FirestoreHelper();

  final TextEditingController searchFieldController = TextEditingController();
  late List<Notice> noticeListToShow;

  @override
  void initState() {
    super.initState();
    noticeListToShow = widget.noticeList;
  }

  @override
  Widget build(BuildContext context) {
    return widget.noticeList.isEmpty
        ? buildMessage("No notice for this subject")
        : Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 24, bottom: 8, left: 8, right: 8),
                color: Colors.white,
                child: CupertinoSearchTextField(
                  onChanged: filterList,
                  controller: searchFieldController,
                ),
              ),
              Expanded(
                child: noticeListToShow.isEmpty
                    ? buildMessage(
                        'No match found for query "${searchFieldController.text}"')
                    : ListView.separated(
                        itemCount: noticeListToShow.length,
                        itemBuilder: (context, index) {
                          return NoticePreview(
                            notice: noticeListToShow[index],
                            trailing: widget.showDeleteNotice
                              ? IconButton(
                                onPressed: () => firestoreHelper.deleteNotice(noticeListToShow[index].id),
                                icon: const Icon(Icons.delete, color: Colors.grey,),
                              ) : null,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 16.0,
                          );
                        },
                      ),
              ),
            ],
          );
  }

  Widget buildMessage(String message) {
    return Center(
      child: Text(message),
    );
  }

  void filterList(String query) {
    noticeListToShow = widget.noticeList
        .where((notice) =>
            notice.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {});
  }
}
