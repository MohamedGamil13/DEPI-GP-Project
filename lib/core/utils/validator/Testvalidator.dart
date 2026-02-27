import 'dart:developer';
import 'dart:io';

import 'package:skillbridge/core/utils/validator/app_validator.dart';

void main() {
  bool allPassed = true;

  void test(String name, String? actual, String? expected) {
    if (actual != expected) {
      log('FAILED: $name - Expected: "$expected" but got: "$actual"');
      allPassed = false;
    } else {
      log('PASSED: $name');
    }
  }

  // Required Field
  test(
    'Required - Empty',
    AppValidator.validateRequired(''),
    'This field is required',
  );
  test(
    'Required - Empty space',
    AppValidator.validateRequired('   '),
    'This field is required',
  );
  test('Required - Valid', AppValidator.validateRequired('value'), null);

  // Full Name
  test(
    'FullName - Empty',
    AppValidator.validateFullName(''),
    'Full name is required',
  );
  test(
    'FullName - Single word',
    AppValidator.validateFullName('John'),
    'Please enter your full name (first and last name)',
  );
  test('FullName - Valid', AppValidator.validateFullName('John Doe'), null);

  // Email
  test(
    'Email - Empty',
    AppValidator.validateEmail(''),
    'Email address is required',
  );
  test(
    'Email - Invalid format',
    AppValidator.validateEmail('invalid-email'),
    'Please enter a valid email address',
  );
  test('Email - Valid', AppValidator.validateEmail('test@example.com'), null);

  // Password
  test(
    'Password - Empty',
    AppValidator.validatePassword(''),
    'Password is required',
  );
  test(
    'Password - Short',
    AppValidator.validatePassword('Short1!'),
    'Password must be at least 8 characters long',
  );
  test(
    'Password - No uppercase',
    AppValidator.validatePassword('nouppercase1!'),
    'Password must contain at least one uppercase letter',
  );
  test(
    'Password - No lowercase',
    AppValidator.validatePassword('NOLOWERCASE1!'),
    'Password must contain at least one lowercase letter',
  );
  test(
    'Password - No number',
    AppValidator.validatePassword('NoNumberPass!'),
    'Password must contain at least one number',
  );
  test('Password - Valid', AppValidator.validatePassword('ValidPass123'), null);

  // Confirm Password
  test(
    'Confirm - empty',
    AppValidator.validateConfirmPassword('', 'Pass'),
    'Please confirm your password',
  );
  test(
    'Confirm - mismatch',
    AppValidator.validateConfirmPassword('Pass123', 'Pass456'),
    'Passwords do not match',
  );
  test(
    'Confirm - match',
    AppValidator.validateConfirmPassword('Pass123', 'Pass123'),
    null,
  );

  // Phone
  test(
    'Phone - Empty',
    AppValidator.validatePhoneNumber(''),
    'Phone number is required',
  );
  test(
    'Phone - Invalid',
    AppValidator.validatePhoneNumber('123'),
    'Please enter a valid phone number',
  );
  test(
    'Phone - Valid (10 digits)',
    AppValidator.validatePhoneNumber('1234567890'),
    null,
  );
  test(
    'Phone - Valid (with +)',
    AppValidator.validatePhoneNumber('+1234567890'),
    null,
  );
  test(
    'Phone - Valid (with spaces/dashes)',
    AppValidator.validatePhoneNumber('+1 234-567-890'),
    null,
  );

  // Phone or Email
  test(
    'PhoneOrEmail - Empty',
    AppValidator.validatePhoneOrEmail(''),
    'Phone or Email is required',
  );
  test(
    'PhoneOrEmail - Invalid format',
    AppValidator.validatePhoneOrEmail('123'),
    'Please enter a valid phone number or email',
  ); // Assuming neither matches
  test(
    'PhoneOrEmail - Valid email',
    AppValidator.validatePhoneOrEmail('test@example.com'),
    null,
  );
  test(
    'PhoneOrEmail - Valid phone',
    AppValidator.validatePhoneOrEmail('+1234567890'),
    null,
  );

  if (allPassed) {
    print('ALL TESTS PASSED SUCCESSFULLY!');
  } else {
    print('SOME TESTS FAILED.');
    exit(1);
  }
}
