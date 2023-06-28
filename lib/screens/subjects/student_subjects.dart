import 'dart:math';

import 'package:college_notice/data/module/firestore_helper.dart';
import 'package:college_notice/data/module/shared_prefs_helper.dart';
import 'package:college_notice/screens/home/students/student_home_page.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/widgets/app_chip.dart';
import 'package:college_notice/widgets/shadow_container.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class StudentSubjects extends StatefulWidget {
  const StudentSubjects({
    super.key,
  });

  @override
  State<StudentSubjects> createState() => _StudentSubjectsState();
}

class _StudentSubjectsState extends State<StudentSubjects> {
  final SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  final FirestoreHelper firestoreHelper = FirestoreHelper();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  String? collegeId, departmentId;
  List<String> subscribedSubjects = [];

  bool subChanges = false;

  @override
  void initState() {
    super.initState();
    collegeId = sharedPrefsHelper.getCollegeId();
    departmentId = sharedPrefsHelper.getDepartmentId();
    subscribedSubjects = sharedPrefsHelper.getSubscribedSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subjects"),
        actions: [
          TextButton(
            onPressed: onSave,
            child: const Text("Save"),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (subChanges) {
            showSaveAlert(context, onSave, () {
              escape(context, const StudentHome());
            });
            return false;
          }

          return true;
        },
        child: collegeId == null || departmentId == null
            ? const Center(
                child: Text("College or department not found"),
              )
            : Center(
                heightFactor: 1,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShadowContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle("Subscribed subjects"),
                          const SizedBox(
                            height: 18,
                          ),
                          subscribedSubjects.isNotEmpty
                              ? Wrap(
                                  spacing: 8,
                                  children: subscribedSubjects
                                      .map(
                                        (subject) => AppChip(
                                          key: Key(subject),
                                          label: subject,
                                          deleteIcon:
                                              const Icon(Icons.remove_circle),
                                          deleteIconColor: Colors.red,
                                          onDeleted: () =>
                                              removeSubject(subject),
                                        ),
                                      )
                                      .toList(),
                                )
                              : buildMessageBox("No subscribed subjects"),
                          const Divider(),
                          buildTitle("Unsubscribed subjects"),
                          const SizedBox(
                            height: 18,
                          ),
                          FutureBuilder(
                            future: firestoreHelper.getSubjects(
                                collegeId!, departmentId!),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return buildMessageBox(
                                    "Error: ${snapshot.error}");
                              }

                              if (snapshot.hasData) {
                                List<String> subs = snapshot.data
                                        ?.where((element) => !subscribedSubjects
                                            .contains(element))
                                        .toList() ??
                                    [];
                                
                                return subs.isNotEmpty
                                    ? Wrap(
                                        spacing: 8,
                                        children: subs
                                            .map(
                                              (subject) => AppChip(
                                                key: Key(subject),
                                                label: subject,
                                                deleteIcon: const Icon(
                                                    Icons.add_circle),
                                                deleteIconColor: Colors.green,
                                                onDeleted: () =>
                                                    addSubject(subject),
                                              ),
                                            )
                                            .toList(),
                                      )
                                    : buildMessageBox("No subjects");
                              }

                              return Wrap(
                                spacing: 8,
                                children: List.generate(
                                    8, (index) => buildLoadingChip()),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildTitle(String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .labelMedium
          ?.copyWith(color: Theme.of(context).primaryColor),
    );
  }

  Widget buildMessageBox(String message) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(message),
      ),
    );
  }

  Widget buildLoadingChip() {
    return Container(
      margin: const EdgeInsets.all(2),
      height: 40,
      width: 77,

      decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background,

      borderRadius: BorderRadius.circular(35),
      ),
    );
  }

  void addSubject(String subject) {
    firebaseMessaging
        .subscribeToTopic(
      generateTopicName(collegeId!, departmentId!, subject),
    )
        .then((value) {
          subChanges = true;
      subscribedSubjects.add(subject);
      setState(() {});
    });
  }

  void removeSubject(String subject) async {
    await firebaseMessaging
        .unsubscribeFromTopic(
      generateTopicName(collegeId!, departmentId!, subject),
    )
        .then(
      (value) {
        subChanges = true;
        subscribedSubjects.remove(subject);
        setState(() {});
      },
    );
  }

  void onSave() {
    showProgressDialog(context);
    sharedPrefsHelper.setSubscribedSubjects(subscribedSubjects).then((_) {
      escape(context, const StudentHome());
    });
  }
}
