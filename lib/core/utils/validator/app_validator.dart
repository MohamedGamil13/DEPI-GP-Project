/// A utility class containing static methods for common text field validations.
/// These validators are designed to be used directly in Flutter [TextFormField] widgets.
class AppValidator {
  
  /// Validates if a required field is left empty.
  /// 
  /// Optionally takes a [fieldName] to customize the error message.
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Validates a full name input.
  /// 
  /// Checks if the field is empty and ensures that at least a first and last name
  /// have been provided (separated by a space).
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) {
      return 'Please enter your full name (first and last name)';
    }
    return null;
  }

  /// Validates an email address using a standard regular expression.
  /// 
  /// Returns an error string if the email is incorrectly formatted or empty.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    // A standard regex for validating email formats
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates a password field with common security requirements.
  /// 
  /// Requirements:
  /// - Minimum 8 characters in length
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one numeric digit
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  /// Validates a password confirmation field.
  /// 
  /// Compares the [value] against the [originalPassword] to ensure they match.
  static String? validateConfirmPassword(String? value, String? originalPassword) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates a phone number.
  /// 
  /// Expects a phone number containing 10-15 digits, ignoring spaces and dashes.
  /// An optional leading '+' is allowed.
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    // Remove spaces and dashes for validation
    final cleaned = value.replaceAll(RegExp(r'\s|-'), '');
    final phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegExp.hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validates a field that can accept either a phone number or an email address.
  /// 
  /// This is commonly used in Sign In screens where users can authenticate
  /// using either piece of information.
  static String? validatePhoneOrEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone or Email is required';
    }
    
    // If the input contains an '@' or english letters, we assume it is an email
    if (value.contains('@') || value.contains(RegExp(r'[a-zA-Z]'))) {
      final emailError = validateEmail(value);
      if (emailError != null) {
        return 'Please enter a valid phone number or email';
      }
    } else {
      // Otherwise, assume it's a phone number
      final phoneError = validatePhoneNumber(value);
      if (phoneError != null) {
        return 'Please enter a valid phone number or email';
      }
    }
    return null;
  }
}
