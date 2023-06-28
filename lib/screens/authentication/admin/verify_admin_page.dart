import 'package:college_notice/data/module/auth_helper.dart';
import 'package:college_notice/interface/process_task.dart';
import 'package:college_notice/utils/global.dart';
import 'package:flutter/material.dart';

class VerifyUserPage extends StatefulWidget {
  final VoidCallback onVerify;

  const VerifyUserPage({super.key, required this.onVerify});

  @override
  State<VerifyUserPage> createState() => _VerifyUserPageState();
}

class _VerifyUserPageState extends State<VerifyUserPage>
    implements ProcessTask {

  late final AuthHelper authHelper = AuthHelper(this);

  @override
  void initState() {
    super.initState();
    authHelper.verifyUserEmail(60);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Verification mail is sent to your email address. Verify by open link.",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Wating for verification..."),
                    LinearProgressIndicator(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void onSuccess() {
    showSnackBar(context, "Email verified successfully", Colors.green);
    // escapeTo(context, const CollegeDetailsPage(), Routes.role);
    widget.onVerify();
  }

  @override
  void onFailed(String? error) {
    showSnackBar(context, error ?? "Something went wrong", Colors.red);
  }

  @override
  void dispose() {
    authHelper.cancelTimer();
    super.dispose();
  }
}
