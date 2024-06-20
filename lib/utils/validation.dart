class Validations {
  static String? isPhoneNumber(String? value) {
    final hasNumber = RegExp(r'^\d+$');
    if (value == null || value.isEmpty || value.length < 10) {
      return 'Entere valid phone number';
    }
    return hasNumber.hasMatch(value) ? null : 'only Number is allowed';
  }

  static String? isEmpty(String? value, String field) =>
      value == null || value.isEmpty ? '$field is Required' : null;

  static String? isNumber(String? value, String field) {
    final hasNumber = RegExp(r'^\d+$');
    if (value == null || value.isEmpty) return '$field is Required';
    return hasNumber.hasMatch(value) ? null : 'only Number is allowed';
  }

  static String formatPhoneNumber(String phoneNumber) {
    final numericPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    return numericPhoneNumber;
  }
}
