String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  if (!value.contains('@') || !value.contains('.')) {
    return 'Please enter a valid email';
  }
  return null;
}

String? passValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  }
  if (value.trim().length < 8) {
    return 'Your password should not be less than 8 characters';
  }
  return null;
}

String? passConfirmValidator(String? value, String? enteredPass) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  }
  if (value.trim() != enteredPass?.trim()) {
    return 'Your password does not match';
  }
  return null;
}
