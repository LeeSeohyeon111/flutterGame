import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

var textFormDecoration = InputDecoration(
  labelText: 'enter your password',
  hintText: 'enter your password',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.lightBlue, width: 1),
    borderRadius: BorderRadius.circular(8),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.orangeAccent, width: 1),
    borderRadius: BorderRadius.circular(8),
  ),
);

bool validateEmail(String email) {
  // Regular expression for email validation
  final RegExp emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  // Check if the email matches the regular expression
  return emailRegex.hasMatch(email);
}

// pick an image
Future<File?> pickImage({
  required bool fromCamera,
  required Function(String) onFail,
}) async {
  File? fileImage;
  if (fromCamera) {
    try {
      final takenPhoto =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (takenPhoto != null) {
        fileImage = File(takenPhoto.path);
      }
    } catch (e) {
      onFail(e.toString());
    }
  } else {
    try {
      final choosenImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (choosenImage != null) {
        fileImage = File(choosenImage.path);
      }
    } catch (e) {
      onFail(e.toString());
    }
  }

  return fileImage;
}