class Validator {
  static String? email(String? value) {
    RegExp emailRegexp = RegExp("[a-z0-9.]+@[a-z0-9]+.[a-z0-9.]+");
    if(value == null || value.isEmpty) return "Please enter email address";

    if(!emailRegexp.hasMatch(value)) return "Invalid email id"; 

    return null;
  }

  static String? phone(String? value) {
    RegExp validEnrollment = RegExp("[0-9]{10}");
    if(value == null || value.isEmpty) return "Please enter phone number";

    if(value.length != 10) {
      return "Phone number should be 10 digit long";
    }
    
    if(!validEnrollment.hasMatch(value)) {
      return "Invalid phone number";
    }

    return null;
  }

  static String? nullableEmail(String? value) {
    RegExp emailRegexp = RegExp("[a-z0-9.]+@[a-z0-9]+.[a-z0-9.]+");
    if(value == null || value.isEmpty) return null;

    if(!emailRegexp.hasMatch(value)) return "Invalid email id"; 

    return null;
  }

  static String? passowrd(String? value) {
    if (value == null || value.isEmpty) return "Password can not be empty";

    if (value.length < 8 || value.length > 32) return "Password length should be in between 8 and 32";

    return null;
  }

  static String? collegeName(String? value) {
    if (value == null || value.isEmpty) {
      return "College name is required";
    }
    return null;
  }

  static String? requiredField(String? value, [String fieldName = "This field"]) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  static String? enrollment(String? value) {
    RegExp validEnrollment = RegExp("[0-9]{12}");
    if(value == null || value.isEmpty) return "Please enter enrollment number";

    if(value.length != 12) {
      return "Enrollment number should be 12 digit long";
    }
    
    if(!validEnrollment.hasMatch(value)) {
      return "Invalid enrollment number";
    }

    return null;
  }
}