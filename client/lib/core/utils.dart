import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
Future<File?> pickAudio() async {
  try {
    final filePickerRes = await FilePicker.pickFile(
      type: FileType.audio,
    );

    if (filePickerRes?.path != null) {
      return File(filePickerRes!.path!);
    }

    return null;
  } catch (e) {
    return null;
  }
}
Future<File?> pickImage() async {
  try {
    final filePickerRes = await FilePicker.pickFile(
      type: FileType.image,
    );

    if (filePickerRes?.path != null) {
      return File(filePickerRes!.path!);
    }

    return null;
  } catch (e) {
    return null;
  }
}

String rgbToHex(Color color){
  return '${color.red.toRadixString(16).padLeft(2,'0')}${color.green.toRadixString(16).padLeft(2,'0')}${color.blue.toRadixString(16).padLeft(2,'0')}';
}

Color hexToColor(String hex){
  return Color(int.parse(hex,radix: 16) + 0xFF000000);
}