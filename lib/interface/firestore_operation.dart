abstract class FirestoreOperation {
  void onOperationSuccess();
  void onOperationFailed([String? error]);
}