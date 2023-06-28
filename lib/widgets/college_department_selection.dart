import 'dart:math';

import 'package:college_notice/data/models/colllege.dart';
import 'package:college_notice/data/models/department.dart';
import 'package:college_notice/data/module/firestore_helper.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/widgets/text_form_field.dart';
import 'package:flutter/material.dart';

class CollegeDepartmnetSelction extends StatefulWidget {
  final void Function(College college, Department department) onNext;

  const CollegeDepartmnetSelction({super.key, required this.onNext});

  @override
  State<CollegeDepartmnetSelction> createState() =>
      _CollegeDepartmnetSelctionState();
}

class _CollegeDepartmnetSelctionState extends State<CollegeDepartmnetSelction> {
  late TextEditingController collegeController;
  final FirestoreHelper firestoreHelper = FirestoreHelper();
  College? selectedCollege;
  Department? selectedDepartment;

  List<College> colleges = [];
  List<Department> departments = [];

  @override
  void initState() {
    super.initState();
    // colleges = [];
    // for(int i = 0; i < 10; i++) {
    //   colleges.add(College(id: "$i", name: "College ${i+1}", admin: "admin", departments: []));
    // }
    
    loadColleges();
  }

  void loadColleges() async {
    colleges = await firestoreHelper.getColleges();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          // key: formKey,
          child: Center(
            child: Container(
              width: min(MediaQuery.of(context).size.width, 400),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    offset: const Offset(1, 1),
                    spreadRadius: 4,
                    blurRadius: 56,
                    color: Theme.of(context).colorScheme.surface,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select College & Department",
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  const SizedBox(
                    height: 56,
                  ),
                  buildField("College", colleges, onCollegeSelect),
                  // AppDropdownMenu(hintText: "College", options: colleges.map((e) => e.name).toList()),
                  const SizedBox(
                    height: 24,
                  ),
                  buildField("Department", departments, onDepartmentSelect),
                  // AppDropdownMenu(hintText: "Department", options: departments.map((e) => e.name).toList()),
                  const SizedBox(
                    height: 56,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: onNextPressed,
                      child: const Text("Next"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, List<Object> options, void Function(Object) onSelected) {
    return Autocomplete<Object>(
        onSelected: onSelected,
        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
          collegeController = textEditingController;
          return AppTextFormField(label: label, controller: textEditingController, focusNode: focusNode,);
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 80,
                  maxHeight: 200
                ),
                child: ListView.builder(
                  itemCount: options.length,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => onSelected(options.elementAt(index)),
                      title: Text("${options.elementAt(index)}", overflow: TextOverflow.ellipsis,),
                    );
                  }
                ),
              ),
            ),
          );
        },
        optionsBuilder: (textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return [];
          }
          return options.where((element) => element
              .toString()
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase()));
        },
      );
  }

  void onCollegeSelect(Object college) async {
    debugPrint("Department selected $selectedCollege");
    
    selectedCollege = college as College;
    departments = await firestoreHelper.getDepartments(college.id);
    setState(() {
      
    });
  }


  void onDepartmentSelect(Object department) {
    selectedDepartment = department as Department;
    debugPrint("Department selected $selectedDepartment");
  }

  void onNextPressed() {
    if (selectedCollege == null) {
      showSnackBar(context, "Please select college");
      return;
    }

    if (selectedCollege == null) {
      showSnackBar(context, "Please select department");
      return;
    }

    widget.onNext(selectedCollege!, selectedDepartment!);
  }
}
