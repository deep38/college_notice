import 'package:college_notice/data/models/department.dart';
import 'package:college_notice/data/models/staff.dart';
import 'package:college_notice/data/module/firestore_helper.dart';
import 'package:college_notice/screens/authentication/admin/verify_admin_page.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/utils/validators.dart';
import 'package:college_notice/widgets/add_dialog.dart';
import 'package:college_notice/widgets/app_list_item.dart';
import 'package:flutter/material.dart';

class DepartmentManagment extends StatefulWidget {
  final Department? department;
  final bool showAdminEdit;

  const DepartmentManagment({
    super.key,
    this.department,
    this.showAdminEdit = false,
  });

  @override
  State<DepartmentManagment> createState() => _DepartmentManagmentState();
}

class _DepartmentManagmentState extends State<DepartmentManagment> {
  final FirestoreHelper firestoreHelper = FirestoreHelper();

  Department? department;

  @override
  void initState() {
    super.initState();

    if (user!.emailVerified) {
      if (widget.department != null) {
        department = widget.department;
      } else {
        firestoreHelper.getDeapartment(user!.email!).then((value) {
          department = value;
          setState(() {});
        });
      }
    } else {
      escape(context, VerifyUserPage(onVerify: () {
        escape(context, const DepartmentManagment());
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(department?.name ?? "...."),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: onAddFacultyPressed,
            tooltip: "Add faculty",
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showAdminEdit) ...[
            buildHeading("Admin"),
            AppListItem(
              title: department?.admin ?? "No admin",
              trailing: IconButton(
                onPressed: onEditAdminPressed,
                icon: const Icon(Icons.edit),
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            buildHeading(
              "Faculty",
            ),
          ],
          Expanded(
            child: department != null
                ? StreamBuilder(
                    stream: firestoreHelper.getStaffStream(
                        department!.collegeId, department!.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text("${snapshot.error}"));
                      }

                      if (snapshot.hasData) {
                        List<Staff>? staffList = snapshot.data?.docs
                            .map((doc) =>
                                Staff.fromFirebaseMap(doc.id, doc.data()))
                            .toList();
                        return staffList != null && staffList.isNotEmpty
                            ? ListView.builder(
                                itemCount: staffList.length,
                                itemBuilder: (context, index) {
                                  final Staff staff = staffList[index];

                                  return AppListItem(
                                    title: staff.name ?? staff.email,
                                    subtitle:
                                        staff.name != null ? staff.email : null,
                                    trailing: IconButton(
                                      onPressed: () =>
                                          firestoreHelper.deleteStaff(staff.id),
                                      icon: const Icon(Icons.delete),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  "No faculty added",
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              );
                      }

                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildHeading(title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: Theme.of(context).disabledColor),
      ),
    );
  }

  void onEditAdminPressed() {
    AddDialog(
      context: context,
      title: department!.admin == null ? "Add admin" : "Edit admin",
      addButtonText: "Ok",
      fields: ["Admin email"],
      validators: {"Admin email": Validator.email},
      onSubmit: onAdminAddRequest,
    ).show();
  }

  void onAdminAddRequest(Map<String, dynamic> data) {
    department!.admin = data["Admin email"];
    firestoreHelper.setAdminOfDepartment(department!, onAdminAddSuccess);
  }

  void onAddFacultyPressed() {
    AddDialog(
      context: context,
      title: "Add faculty",
      fields: ["Faculty email"],
      validators: {"Faculty email": Validator.email},
      onSubmit: onFacultyAddRequest,
    ).show();
  }

  void onFacultyAddRequest(Map<String, dynamic> data) {
    // widget.department.staff.add(staff);
    firestoreHelper.addStaff(
        Staff.firebaseMap(
          email: data['Faculty email'],
          collegeId: department!.collegeId,
          departemntId: department!.id,
          subjects: [],
        ),
        onFacultyAddSuccess);
  }

  void onAdminAddSuccess() {
    showSnackBar(context, "Admin added successfully");
    setState(() {});
  }

  void onFacultyAddSuccess() {
    showSnackBar(context, "Faculty added successfully");
  }
}
