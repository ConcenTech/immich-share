import 'package:form_field_validator/form_field_validator.dart';

import '../../constants/constants.dart';

class Validators {
  // static final required = RequiredValidator(errorText: kRequired);
  static const required = _requiredValidator;

  static String? _requiredValidator(Object? value) {
    if (value is String) {
      return value.isEmpty ? kRequired : null;
    }
    return value == null ? kRequired : null;
  }

  static String? requiredInt(String? value) {
    if (value == null) {
      return kRequired;
    }

    if (int.tryParse(value) == null) {
      return 'Invalid value';
    }

    return null;
  }

  static final password = MultiValidator(
    [
      RequiredValidator(errorText: kRequired),
      MinLengthValidator(
        6,
        errorText: 'Password must be at least 6 digits long',
      ),
      PatternValidator(
        r'(?=.*?[#?!@$%^&*-=])',
        errorText: 'Passwords must have at least one special character',
      ),
    ],
  ).call;

  static final postcode = MultiValidator([
    RequiredValidator(errorText: kRequired),
    PatternValidator(
      r'^([A-Z]{1,2}\d{1,2}[A-Z]?)\s*(\d[A-Z]{2})$',
      errorText: 'Not a valid postcode',
    ),
  ]);

  static final email = MultiValidator([
    RequiredValidator(errorText: kRequired),
    optionalEmail,
  ]).call;

  static final optionalEmail =
      EmailValidator(errorText: 'Please enter a valid email');

  static String? passwordMatch(
      {required String? value1, required String? value2}) {
    if ((value1 ?? '1') != (value2 ?? '2')) {
      return 'Passwords must match';
    }
    return null;
  }

  static String? numberMaxLength(
      {required String? value, required double max}) {
    if (value == null) {
      return 'Required';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Error';
    }
    if (number > max) {
      return 'Value too high';
    }
    return null;
  }
}