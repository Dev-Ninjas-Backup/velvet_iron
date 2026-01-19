class OtpValidation {
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the OTP';
    }
    if (value.length < 4) {
      return 'Please enter the complete OTP';
    }
    return null;
  }
}
