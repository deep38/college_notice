import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notice/data/models/colllege.dart';
import 'package:college_notice/data/models/department.dart';
import 'package:college_notice/data/models/notice.dart';
import 'package:college_notice/data/models/staff.dart';
import 'package:flutter/material.dart';

class FirestoreHelper {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  void addCollege(Map<String, dynamic> college,
      [Function(String id)? onComplete]) async {
    debugPrint("Adding college....");
    DocumentReference docRef =
        await firebaseFirestore.collection('colleges').add(college);
    debugPrint("College added successfully: ${docRef.id}");
    onComplete?.call(docRef.id);
  }

  void addDepartment(Map<String, dynamic> department,
      [Function? onComplete]) async {
    await firebaseFirestore.collection('departments').add(department);

    onComplete?.call();
  }

  void setAdminOfDepartment(Department department,
      [VoidCallback? onComplete]) async {
    await firebaseFirestore
        .collection('departments')
        .doc(department.id)
        .set({'admin': department.admin}, SetOptions(merge: true));

    onComplete?.call();
  }

  void addStaff(Map<String, dynamic> staff, [VoidCallback? onComplete]) async {
    await firebaseFirestore.collection('staff').add(staff);

    onComplete?.call();
  }

  Future<void> addSubject(Staff staff, [VoidCallback? onComplete]) async {
    await firebaseFirestore
        .collection('staff')
        .doc(staff.id)
        .set({'subjects': staff.subjects}, SetOptions(merge: true));

    onComplete?.call();
  }

  Future<String> addNotice(Map<String, dynamic> notice) async {
    return (await firebaseFirestore
          .collection('notice')
          .add(notice)).id;

  }

  Future<College> getCollege(String adminEmail) async {
    QueryDocumentSnapshot<Map<String, dynamic>> collegeSnap =
        (await firebaseFirestore
                .collection('colleges')
                .where('admin', isEqualTo: adminEmail)
                .get())
            .docs
            .first;

    return College.fromFirebaseMap(collegeSnap.id, collegeSnap.data());
  }

  Future<Department> getDeapartment(String adminEmail) async {
    QueryDocumentSnapshot<Map<String, dynamic>> departmentSnap =
        (await firebaseFirestore
                .collection('departments')
                .where('admin', isEqualTo: adminEmail)
                .get())
            .docs
            .first;

    return Department.fromFirebaseMap(departmentSnap.id, departmentSnap.data());
  }

  Future<Staff> getStaff(String adminEmail) async {
    QueryDocumentSnapshot<Map<String, dynamic>> staffSnap =
        (await firebaseFirestore
                .collection('staff')
                .where('email', isEqualTo: adminEmail)
                .get())
            .docs
            .first;

    return Staff.fromFirebaseMap(staffSnap.id, staffSnap.data());
  }

  // Future<String> getCollegeName() async {
  //   Map<String, dynamic>? data = (await firebaseFirestore.collection('colleges').doc(collegeId).get()).data();

  //   return data!['name'];
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDepartmentStream(
      String collegeId) {
    return firebaseFirestore
        .collection('departments')
        .where("collegeId", isEqualTo: collegeId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStaffStream(
      String collegeId, String departmentId) {
    return firebaseFirestore
        .collection('staff')
        .where('collegeId', isEqualTo: collegeId)
        .where('departmentId', isEqualTo: departmentId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNoticeStream(List<String> subjectList) {
    return firebaseFirestore
        .collection('notice')
        .where('subject', whereIn: subjectList)
        .snapshots();
  }

    Stream<QuerySnapshot<Map<String, dynamic>>> getNoticeStreamForSubject(String subject) {
    return firebaseFirestore
        .collection('notice')
        .where('subject', isEqualTo: subject)
        .snapshots();
  }

  Future<List<String>> getSubjects(
      String collegeId, String departmentId) async {

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firebaseFirestore
        .collection('staff')
        .where('collegeId', isEqualTo: collegeId)
        .where('departmentId', isEqualTo: departmentId)
        .get();

    List<String> subjects = [];

    for (var doc in querySnapshot.docs) {
      List<String> docSubjects = List<String>.from(doc.data()['subjects']);
      subjects.addAll(docSubjects);
    }
    debugPrint("Subjects: $subjects");
    return subjects;
  }

  Future<String> getCollegeNameById(String id) async {
    return (await firebaseFirestore.collection('colleges').doc(id).get()).data()!['name'];
  }

  Future<String> getDepartmentNameById(String id) async {
    return (await firebaseFirestore.collection('departments').doc(id).get()).data()!['name'];
  }

  Future<String> getCollegeAndDepartmentNameById(String collegeId, String departmentId) async {
    return "${await getCollegeNameById(collegeId)}, ${await getDepartmentNameById(departmentId)}";
  }


  Future<List<College>> getColleges() async {
    List<DocumentSnapshot<Map<String, dynamic>>> docs =
        (await firebaseFirestore.collection('colleges').get()).docs;

    return docs
        .map((doc) => College.fromFirebaseMap(doc.id, doc.data()!))
        .toList();
  }

  Future<List<Department>> getDepartments(String collegeId) async {
    List<DocumentSnapshot<Map<String, dynamic>>> docs = (await firebaseFirestore
            .collection('departments')
            .where('collegeId', isEqualTo: collegeId)
            .get())
        .docs;

    return docs
        .map((doc) => Department.fromFirebaseMap(doc.id, doc.data()!))
        .toList();
  }

  Future<bool> checkForAdminExist(
      String college, String department, String email) async {
    Map<String, dynamic>? data = (await firebaseFirestore
            .collection('departments')
            .doc(department)
            .get())
        .data();
    if (data != null) {
      return email == data['admin'];
    }

    return false;
  }

  Future<Staff?> checkForStaffExist(
      String college, String department, String email) async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> facultyList =
        (await firebaseFirestore
                .collection('staff')
                .where('collegeId', isEqualTo: college)
                .where('departmentId', isEqualTo: department)
                .where('email', isEqualTo: email)
                .get())
            .docs;

    if (facultyList.isEmpty) return null;
    return Staff.fromFirebaseMap(
        facultyList.first.id, facultyList.first.data());
  }


  void deleteStaff(String id) async {
    await firebaseFirestore.collection('staff').doc(id).delete();
  }

  void deleteNotice(String id) async {
    await firebaseFirestore.collection('notice').doc(id).delete();
  }
}
