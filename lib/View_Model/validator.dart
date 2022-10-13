import '../model/constant.dart';

class Validator {
  static String? validateBudgetTitle(String? value) {
    // if null or empty string
    if (value == null || value.isEmpty) {
      return ValidationError.requiredFieldError;
    }
    // if title is less than 4 characters
    else if (value.length < 4) {
      return ValidationError.budgetTitleLengthError;
    }
    // all good
    else {
      return null;
    }
  }

  static String? validateAccountTitle(String? value) {
    // if null or empty string
    if (value == null || value.isEmpty) {
      return ValidationError.requiredFieldError;
    }
    // if title is less than 4 characters
    else if (value.length < 4) {
      return ValidationError.titleLengthError;
    }
    // all good
    else {
      return null;
    }
  }
}
