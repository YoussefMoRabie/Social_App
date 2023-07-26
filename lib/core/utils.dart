import 'package:file_picker/file_picker.dart';

import 'package:intl/intl.dart';

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  if (!value.contains('@') || !value.contains('.')) {
    return 'Please enter a valid email';
  }
  return null;
}

String? usernameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }
  return null;
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );

  return image;
}

String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
  DateTime notificationDate = DateTime.parse(dateString);
  final date2 = DateTime.now();
  final difference = date2.difference(notificationDate);
  if (difference.inDays > 7 || difference.inDays < 0) {
    return DateFormat('dd MMM yyyy').format(notificationDate);
  } else if (difference.inDays > 2) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays >= 1) {
    return numericDates ? '1 day ago' : 'Yesterday';
  } else if (difference.inHours > 1) {
    return '${difference.inHours} hrs ago';
  } else if (difference.inMinutes > 1) {
    return '${difference.inMinutes} mins ago';
  } else if (difference.inSeconds > 3) {
    return '${difference.inSeconds} secs ago';
  } else {
    return 'Just now';
  }
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

String? keyValidator(String? key) {
  if (key == null || key.isEmpty) {
    return 'Please enter a key';
  }
  return null;
}

double getPostPadding(String post) {
  int pad = (post.length / 35).ceil();
  switch (pad) {
    case 1:
      return 0.25;
    case 2:
      return 0.27;
    case 3:
      return 0.29;
    case 4:
      return 0.31;
    case 5:
      return 0.33;
    default:
      return 0.35;
  }
}
