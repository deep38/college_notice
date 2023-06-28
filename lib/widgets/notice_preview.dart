import 'package:college_notice/data/models/notice.dart';
import 'package:college_notice/screens/notice_view_page.dart';
import 'package:college_notice/utils/global.dart';
import 'package:flutter/material.dart';

class NoticePreview extends StatelessWidget {
  final Notice notice;
  final Widget? trailing;

  const NoticePreview({
    super.key,
    required this.notice,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
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
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if(trailing != null) trailing!
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(Icons.share),
              //   color: Colors.grey,
              // ),
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
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                goTo(context, NoticeView(notice: notice));
              },
              child: Text(
                "READ MORE",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
