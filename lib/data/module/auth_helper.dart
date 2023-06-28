
import 'dart:async';

import 'package:college_notice/interface/process_task.dart';
import 'package:college_notice/utils/annotation.dart';
import 'package:college_notice/utils/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

final ValueNotifier<bool> userAuthNotifier = ValueNotifier(false);

class AuthHelper {
  Timer? _timer;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final ProcessTask processTask;

  AuthHelper(this.processTask);

  AuthHelper.withAuthStateListener(this.processTask) {
    firebaseAuth.authStateChanges().listen((newUser) {
      user = newUser;
      if(newUser != null) processTask.onSuccess();
    });
  }

  void login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e) {
      if (e.code == 'user-not-found') {
        processTask.onFailed('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        processTask.onFailed('Wrong password provided for that user.');
      } else {
        processTask.onFailed(e.message);
      }
    } on Exception catch (e) {
      processTask.onFailed(e.toString());
    }
  }

  void register(String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        processTask.onFailed('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        processTask.onFailed('The account already exists for that email.');
      } else {
        processTask.onFailed(e.message);
      }
    } catch (e) {
      processTask.onFailed(e.toString());
    }
  }

  /// Units used for time is in seconds
  @TimeUnit("seconds")
  void verifyUserEmail(int timeout, [int interval = 1]) {
    user?.sendEmailVerification();

    _timer = Timer.periodic(Duration(seconds: interval), (timer) async {
      debugPrint("User: $user, Varified: ${user?.emailVerified}");
      await FirebaseAuth.instance.currentUser?.reload(); 
      if(FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
        user = FirebaseAuth.instance.currentUser;
        processTask.onSuccess();
        timer.cancel();
      }
    });

  }
  
  void cancelTimer() {
    if(_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }
  
}