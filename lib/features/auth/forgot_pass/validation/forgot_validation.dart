import 'package:velvet_iron/core/utils/validators/app_validator.dart';

class ForgotValidation {
  static String? validateEmail(String? value) {
    return AppValidator.validateEmail(value);
  }
}
