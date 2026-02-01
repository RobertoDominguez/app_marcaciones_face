import 'dart:typed_data';

/// Clase para almacenar info de cada imagen
class ImageData {
  final String? path; // Mobile
  final Uint8List? bytes; // Web

  ImageData({this.path, this.bytes});
}
