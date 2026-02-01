import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class PickedImageResult {
  final String? path;
  final Uint8List? bytes;

  PickedImageResult({this.path, this.bytes});
}

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<PickedImageResult?> pickImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.front,
    );

    if (file == null) return null;

    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      return PickedImageResult(bytes: bytes);
    } else {
      return PickedImageResult(path: file.path);
    }
  }
}
