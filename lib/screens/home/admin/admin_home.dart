import 'package:college_notice/data/models/colllege.dart';
import 'package:college_notice/data/models/department.dart';
import 'package:college_notice/data/module/firestore_helper.dart';
import 'package:college_notice/screens/authentication/admin/verify_admin_page.dart';
import 'package:college_notice/screens/home/admin/admin_department_managment_page.dart';
import 'package:college_notice/screens/home/admin/admin_drawer.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/widgets/add_dialog.dart';
import 'package:college_notice/widgets/app_list_item.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController departmentNameController =
      TextEditingController();

  final FirestoreHelper firestoreHelper = FirestoreHelper();


  College? college;

  @override
  void initState() {
    super.initState();
    if(user!.emailVerified) {
      firestoreHelper.getCollege(user!.email!).then(
      (value) {
        college = value;
        setState(() {});
      }
    );
    } else {
      escape(context, VerifyUserPage(onVerify: () {
        escape(context, const AdminHome());
      }));
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Departments"),
        actions: college != null
          ? [
          IconButton(
            onPressed: onAddDepartmentPressed,
            tooltip: "Add department",
            icon: const Icon(Icons.add),
          )
        ]
        : null,
      ),
      drawer: Drawer(
        child: AdminDrawer(
            name: college?.name ?? ".....",
            email: user!.email!,
          ),
      ),
      body: college != null
        ? StreamBuilder(
        stream: firestoreHelper.getDepartmentStream(college!.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          if (snapshot.hasData) {
            college!.departments = snapshot.data!.docs
                .map((doc) => Department.fromFirebaseMap(doc.id, doc.data()))
                .toList();
            return college?.departments != null && college!.departments.isNotEmpty
                ? ListView.builder(
                    itemCount: college!.departments.length,
                    itemBuilder: (context, index) {
                      return AppListItem(
                        title: college!.departments[index].name,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DepartmentManagment(
                              department: college!.departments[index],
                              showAdminEdit: true,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "No departments added",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  );
          }

          return const Center(child: CircularProgressIndicator.adaptive());
        },
      )
      : const Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  void onAddDepartmentPressed() {
    AddDialog(
            context: context,
            title: "Add department",
            fields: ["Department name"],
            onSubmit: onDepartmentAddRequest)
        .show();
  }

  void onDepartmentAddRequest(Map<String, dynamic> data) async {
    assert(college?.id != null);
    
    firestoreHelper.addDepartment(Department.firebaseMap(name: data['Department name'], admin: null, collegeId: college!.id), onDepartmentAddSuccess);
  }

  void onDepartmentAddSuccess() {
    showSnackBar(context, "Added successfully");
  }
}
