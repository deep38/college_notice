import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  final String collegeIdKey = "COLLEGE_ID";
  final String departmentIdKey = "DEPARTMENT_ID";
  final String userRoleKey = "USER_ROLE";
  final String subscribedSubjectsKey = "SUBSCRIBED_SUBJECTS";
  
  static SharedPreferences? _sharedPrefs;

  static Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  Future<void> setCollegeId(String id) async {
    if(_sharedPrefs == null) await init();
    _sharedPrefs?.setString(collegeIdKey, id);
  }

  Future<void> setDepartmentId(String id) async {
    if(_sharedPrefs == null) await init();
    _sharedPrefs?.setString(departmentIdKey, id);
  }

  Future<void> setUserRole(String role) async {
    if(_sharedPrefs == null) await init();
    _sharedPrefs?.setString(userRoleKey, role);
  }

  Future<void> setSubscribedSubjects(List<String> subjects) async {
    if(_sharedPrefs == null) await init();
    _sharedPrefs?.setStringList(subscribedSubjectsKey, subjects);
  }

  String? getCollegeId() {
    return _sharedPrefs?.getString(collegeIdKey);
  }

  String? getDepartmentId() {
    return _sharedPrefs?.getString(departmentIdKey);
  }

  String? getUserRole() {
    return _sharedPrefs?.getString(userRoleKey);
  }

  List<String> getSubscribedSubjects() {
    return _sharedPrefs?.getStringList(subscribedSubjectsKey) ?? [];
  }
}