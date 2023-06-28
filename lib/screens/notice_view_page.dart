import 'package:college_notice/data/models/notice.dart';
import 'package:college_notice/utils/global.dart';
import 'package:flutter/material.dart';

class NoticeView extends StatelessWidget {
  final Notice notice;
  const NoticeView({
    super.key,
    required this.notice,
  });

  @override
  Widget build(BuildContext context) {

    String subject = notice.subject.split("-").last.replaceAll("_", " ");
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          subject,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      notice.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.share),
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text("${getMonthName(notice.dateTime.month)} ${notice.dateTime.day}, ${notice.dateTime.year} ${('${notice.dateTime.hour}').padLeft(2, '0')}:${('${notice.dateTime.second}').padLeft(2, '0')}"),
              const SizedBox(
                height: 24,
              ),
              Text(
                notice.content,
              )
            ],
          ),
        ),
      ),
    );
  }
}
