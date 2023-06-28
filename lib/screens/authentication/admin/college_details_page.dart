import 'package:college_notice/data/models/colllege.dart';
import 'package:college_notice/data/module/firestore_helper.dart';
import 'package:college_notice/data/module/shared_prefs_helper.dart';
import 'package:college_notice/screens/home/admin/admin_home.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/utils/routes.dart';
import 'package:college_notice/utils/validators.dart';
import 'package:college_notice/widgets/text_form_field.dart';
import 'package:flutter/material.dart';

/// name
/// address
/// contact number
/// email
/// site
///

class CollegeDetailsPage extends StatefulWidget {
  const CollegeDetailsPage({super.key});

  @override
  State<CollegeDetailsPage> createState() => _CollegeDetailsPageState();
}

class _CollegeDetailsPageState extends State<CollegeDetailsPage> {
  final FirestoreHelper firestoreHelper = FirestoreHelper();
  final SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController siteController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  int state = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter college name",
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                  const SizedBox(
                    height: 56,
                  ),
                  AppTextFormField(
                    label: "Name",
                    controller: nameController,
                    validator: Validator.collegeName,
                    enabled: state == 0,
                  ),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  // AppTextFormField(
                  //   label: "Email",
                  //   keyboardType: TextInputType.emailAddress,
                  //   controller: emailController,
                  //   validator: Validator.nullableEmail,
                  //   enabled: state == 0,
                  // ),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  // AppTextFormField(
                  //   label: "Contact number",
                  //   keyboardType: TextInputType.phone,
                  //   controller: numberController,
                  //   enabled: state == 0,
                  // ),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  // AppTextFormField(
                  //   label: "Site",
                  //   keyboardType: TextInputType.url,
                  //   controller: siteController,
                  //   enabled: state == 0,
                  // ),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  // AppTextFormField(
                  //   label: "Address",
                  //   minLines: 4,
                  //   maxLines: 4,
                  //   keyboardType: TextInputType.streetAddress,
                  //   controller: addressController,
                  //   enabled: state == 0,
                  // ),
                  const SizedBox(
                    height: 56,
                  ),
                  ElevatedButton(
                    onPressed: state == 0 ? onDonePressed : null,
                    child: state == 0
                        ? const Text("Done")
                        : const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(),
                          ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onDonePressed() {
    if (formKey.currentState?.validate() ?? false) {
      setState(() {
        state = 1;
      });
      
      assert(user != null && user?.email != null);
      firestoreHelper.addCollege(College.firebaseMap(name: nameController.text, admin: user!.email!), onCollegeAddSuccessfully);
    }
  }

  void onCollegeAddSuccessfully(String id) async {
    collegeId = id;
    
    showSnackBar(context, "Successfully added", Colors.green);
    escapeTo(
      context,
      const AdminHome(),
      Routes.role
    );
    await sharedPrefsHelper.setCollegeId(id);
    debugPrint("College saved: ${sharedPrefsHelper.getCollegeId()}");
  }
}
