/// A utility class for validating user inputs.
class Validator {
  /// Checks if the [value] has at least [minLength] characters.
  static bool hasMinimumLength(String? value, {int minLength = 1}) {
    if (value == null) return false;
    return value.trim().length >= minLength;
  }

  /// Validates if the [value] is a valid email address.
  static bool isValidEmail(String? value) {
    if (value == null) return false;
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value);
  }

  /// Validates if the [value] is a valid password with at least [minLength] characters.
  static bool isValidPassword(String? value, {int minLength = 6}) {
    if (value == null) return false;
    return value.trim().length >= minLength;
  }

  /// Validates if the [value] is a valid Egyptian phone number.
  static bool isValidEgyptianPhoneNumber(String? value) {
    if (value == null) return false;
    return RegExp(r'^(010|011|012|015)[0-9]{8}$').hasMatch(value);
  }
}
