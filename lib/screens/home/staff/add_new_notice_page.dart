import 'package:college_notice/data/models/notice.dart';
import 'package:college_notice/data/models/staff.dart';
import 'package:college_notice/data/module/fcm_api.dart';
import 'package:college_notice/data/module/firestore_helper.dart';
import 'package:college_notice/utils/global.dart';
import 'package:flutter/material.dart';

class AddNewNotice extends StatefulWidget {
  final Staff staff;

  const AddNewNotice({
    super.key,
    required this.staff,
  });

  @override
  State<AddNewNotice> createState() => _AddNewNoticeState();
}

class _AddNewNoticeState extends State<AddNewNotice> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  FcmApi fcmApi = FcmApi();
  FirestoreHelper firestoreHelper = FirestoreHelper();
  ValueNotifier<String?> selectedSubjectListener = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: onSendPressed,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("For subject:"),
              ),
              GestureDetector(
                onTap: shwoSelectSubjectDialog,
                child: Chip(
                  label: ValueListenableBuilder(
                    valueListenable: selectedSubjectListener,
                    builder: (context, value, child) => Text(
                      value ?? "No subject selected",
                    ),
                  ),
                  shape: const StadiumBorder(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 1,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 24,
                    ),
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    hintText: "Title",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16))),
                controller: titleController,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: contentController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                autofocus: true,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: "Start writing...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(width: 2)),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.format_bold),
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.format_italic)),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.format_underline)),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey,
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.format_align_left)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.format_align_center)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.format_align_right)),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey,
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.image_rounded)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.attach_file_rounded)),
              ],
            ),
          )
        ],
      ),
    );
  }

  void shwoSelectSubjectDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select subject"),
          content: buildSubjectList(),
        );
      },
    );
  }

  Widget buildSubjectList() {
    return Wrap(
      spacing: 8,
      children: widget.staff.subjects
          .map(
            (sub) => GestureDetector(
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  selectedSubjectListener.value = sub;
                });
              },
              child: Chip(
                label: Text(sub),
                shape: const StadiumBorder(),
              ),
            ),
          )
          .toList(),
    );
  }

  void onSendPressed() async {
    if (selectedSubjectListener.value == null) {
      showSnackBar(context, "Please select subject");
      return;
    }
    if (titleController.text.isEmpty) {
      showSnackBar(context, "Please enter title");
      return;
    }
    if (contentController.text.isEmpty) {
      showSnackBar(context, "Please enter some content");
      return;
    }

    showProgressDialog(context);

    String topic = generateTopicName(widget.staff.collegeId,
        widget.staff.departmentId, selectedSubjectListener.value!);
    String noticeId = await firestoreHelper.addNotice(
      Notice.firebaseMap(
        title: titleController.text,
        content: contentController.text,
        dateTime: DateTime.now(),
        subject: topic,
      ),
    );
    fcmApi
        .sendNotificationToTopic(
            noticeId, topic, titleController.text, contentController.text)
        .then((value) {
      titleController.clear();
      contentController.clear();
      selectedSubjectListener.value = null;
      Navigator.pop(context);
      showSnackBar(context, "Notice send successfully", Colors.green);
    });
  }
}
