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

  static String? validateAccountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationError.requiredFieldError;
    }
    // if account number is less than 4 characters
    else if (value.length < 8) {
      return ValidationError.accountNumberLengthError;
    }
    // all good
    else {
      return null;
    }
  }

  static String? validateAccountRate(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationError.requiredFieldError;
    }
    // if account rate is less than 1 character
    else if (value.isEmpty) {
      return ValidationError.accountRateError;
    } else if (double.tryParse(value) == null) {
      return ValidationError.accountRateNANError;
    }
    // all good
    else {
      return null;
    }
  }

  static String? validateWebsite(String? value) {
    RegExp exp = RegExp(r'.*\..*');

    if (value == null || value.isEmpty) {
      return ValidationError.requiredFieldError;
    }
    // if website is less than 5 characters
    else if (value.length < 5) {
      return ValidationError.websiteLengthError;
    } else if (!exp.hasMatch(value)) {
      return ValidationError.websiteFormatError;
    }
    // all good
    else {
      return null;
    }
  }
}
