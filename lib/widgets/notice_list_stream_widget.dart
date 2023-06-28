import 'dart:math';

import 'package:college_notice/data/models/notice.dart';
import 'package:college_notice/data/module/firestore_helper.dart';
import 'package:college_notice/widgets/notice_list.dart';
import 'package:flutter/material.dart';

class NoticeListStream extends StatelessWidget {
  final FirestoreHelper firestoreHelper = FirestoreHelper();
  final String subject;
  final bool showDeleteNotice;

  NoticeListStream(
      {super.key, required this.subject, this.showDeleteNotice = false});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestoreHelper.getNoticeStreamForSubject(subject),
      builder: (context, snapshot) {
        debugPrint("ListUpdated: ");
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          debugPrint("Focus: ${snapshot.data!.docs}");
          List<Notice> notices = snapshot.data!.docs
              .map((e) => Notice.fromFirebaseMap(e.id, e.data()))
              .toList();
          return NoticeList(
            key: Key(genereateRandomKey(10)),
            noticeList: notices,
            showDeleteNotice: showDeleteNotice,
          );
        }
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }

  String genereateRandomKey(int length) {
    String alpha = 'abcdefghijklmnopqrstuvwxyz';
    String numbers = '0123456789';

    String key = "";

    for (int i = 0; i < length; i++) {
      switch (Random().nextInt(2)) {
        case 0:
          key += alpha[Random().nextInt(alpha.length)];
          break;
        case 1:
          key += numbers[Random().nextInt(numbers.length)];
          break;
        default:
          key += alpha[Random().nextInt(alpha.length)];
          break;
      }
    }
    return key;
  }
}
