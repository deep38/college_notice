import 'dart:math';

import 'package:college_notice/data/models/staff.dart';
import 'package:college_notice/data/module/firestore_helper.dart';
import 'package:college_notice/screens/home/staff/staff_home_page.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/widgets/shadow_container.dart';
import 'package:college_notice/widgets/text_form_field.dart';
import 'package:flutter/material.dart';

class StaffSubjectPage extends StatefulWidget {
  final Staff staff;

  const StaffSubjectPage({
    super.key,
    required this.staff,
  });

  @override
  State<StaffSubjectPage> createState() => _StaffSubjectPageState();
}

class _StaffSubjectPageState extends State<StaffSubjectPage> {
  final TextEditingController subjectController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final FirestoreHelper firestoreHelper = FirestoreHelper();

  bool changesMade = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add subject"),
        actions: [
          TextButton(
            onPressed: onDonePressed,
            child: const Text("Save"),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (changesMade) {
            showSaveAlert(context, onDonePressed, () {
              escape(
                context,
                const StaffHome(),
              );
            });
            return false;
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: min(MediaQuery.of(context).size.width, 400),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: ShadowContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              label: "Subject name",
                              focusNode: focusNode,
                              controller: subjectController,
                              onFieldSubmitted: addSubject,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                            onPressed: addSubject,
                            child: const Text("Add"),
                          )
                        ],
                      ),
                      const Divider(),
                      Wrap(
                        spacing: 8,
                        children: widget.staff.subjects
                            .map((e) => Chip(
                                  label: Text(e),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28)),
                                  deleteIcon: const Icon(
                                    Icons.remove_circle,
                                  ),
                                  deleteIconColor: Colors.red,
                                  onDeleted: () => removeSubject(e),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addSubject([String? subject]) {
    subject ??= subjectController.text;
    if (subject.isNotEmpty && !widget.staff.subjects.contains(subject)) {
      changesMade = true;
      widget.staff.subjects.add(subject);
      subjectController.clear();
      focusNode.requestFocus();
      setState(() {});
    }
  }

  void removeSubject(String subject) {
    widget.staff.subjects.remove(subject);
    changesMade = true;
    setState(() {});
  }

  void onDonePressed() {
    showProgressDialog(context);
    firestoreHelper.addSubject(widget.staff).then(
      (value) {
        escape(context, const StaffHome());
      },
    );
  }
}
