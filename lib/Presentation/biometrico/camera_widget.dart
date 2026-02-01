// import 'dart:io';
// import 'dart:typed_data';
// import 'package:app_marcaciones_face/Entities/ImageData.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import '../../assets/widgets/buttons.dart';
// import '../../assets/widgets/dialog.dart';



// /// Widget unificado para cámara (Web y Mobile)
// class CameraWidget extends StatefulWidget {
//   final Function(ImageData imageData) onImage;
//   final int minImages;
//   final int maxImages;

//   const CameraWidget({
//     Key? key,
//     required this.onImage,
//     this.minImages = 3,
//     this.maxImages = 5,
//   }) : super(key: key);

//   @override
//   State<CameraWidget> createState() => _CameraWidgetState();
// }

// class _CameraWidgetState extends State<CameraWidget> {
//   CameraController? controller;
//   List<CameraDescription> cameras = [];
//   bool isInitialized = false;
//   bool faceDetected = false; // Para overlay Mobile
//   final faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableContours: false,
//       enableLandmarks: false,
//       enableClassification: false,
//     ),
//   );

//   List<ImageData> images = [];

//   @override
//   void initState() {
//     super.initState();
//     initCameras();
//   }

//   Future<void> initCameras() async {
//     try {
//       cameras = await availableCameras();
//       if (cameras.isNotEmpty) {
//         controller = CameraController(cameras[0], ResolutionPreset.medium);
//         await controller!.initialize();
//         if (!kIsWeb) startImageStream();
//         setState(() {
//           isInitialized = true;
//         });
//       }
//     } catch (e) {
//       print("Error al inicializar la cámara: $e");
//       showAlertDialogMessage(context, "Error", "No se pudo inicializar la cámara");
//     }
//   }

//   // Solo Mobile: streaming para detectar cara
//   void startImageStream() {
//     controller?.startImageStream((CameraImage image) async {
//       try {
//         final WriteBuffer allBytes = WriteBuffer();
//         for (Plane plane in image.planes) {
//           allBytes.putUint8List(plane.bytes);
//         }
//         final bytes = allBytes.done().buffer.asUint8List();
//         final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
//         final InputImageRotation imageRotation = InputImageRotation.rotation0deg;
//         final InputImageFormat inputImageFormat = InputImageFormatMethods.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;
//         final planeData = image.planes.map(
//           (Plane plane) {
//             return InputImagePlaneMetadata(
//               bytesPerRow: plane.bytesPerRow,
//               height: plane.height,
//               width: plane.width,
//             );
//           },
//         ).toList();

//         final inputImage = InputImage.fromBytes(
//           bytes: bytes,
//           metadata: InputImageData(
//             size: imageSize,
//             imageRotation: imageRotation,
//             inputImageFormat: inputImageFormat,
//             planeData: planeData,
//           ),
//         );

//         final faces = await faceDetector.processImage(inputImage);
//         if (mounted) {
//           setState(() {
//             faceDetected = faces.isNotEmpty;
//           });
//         }
//       } catch (e) {
//         // Ignorar errores temporales de stream
//       }
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     faceDetector.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!isInitialized || controller == null) {
//       return Center(child: CircularProgressIndicator());
//     }

//     return Column(
//       children: [
//         // Cámara con overlay
//         Expanded(
//           child: Stack(
//             children: [
//               CameraPreview(controller!),
//               if (!kIsWeb)
//                 Positioned(
//                   bottom: 10,
//                   left: 10,
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         color: faceDetected ? Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.7),
//                         borderRadius: BorderRadius.circular(8)),
//                     child: Text(
//                       faceDetected ? "Cara detectada" : "No hay cara",
//                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         SizedBox(height: 10),

//         // Botón tomar foto
//         buttonPrimary(context, "Tomar Foto", () async {
//           if (images.length >= widget.maxImages) {
//             showAlertDialogMessage(context, "Aviso", "Máximo ${widget.maxImages} fotos permitidas");
//             return;
//           }

//           try {
//             XFile file = await controller!.takePicture();
//             if (kIsWeb) {
//               Uint8List bytes = await file.readAsBytes();
//               setState(() {
//                 images.add(ImageData(path: file.path, bytes: bytes));
//               });
//               widget.onImage(ImageData(path: file.path, bytes: bytes));
//             } else {
//               setState(() {
//                 images.add(ImageData(path: file.path));
//               });
//               widget.onImage(ImageData(path: file.path));
//             }
//           } catch (e) {
//             showAlertDialogMessage(context, "Error", "No se pudo tomar la foto: $e");
//           }
//         }),

//         SizedBox(height: 10),
//         // Miniaturas de fotos
//         buildImagePreview(),
//       ],
//     );
//   }

//   Widget buildImagePreview() {
//     if (images.isEmpty) return Container(height: 80);
//     return SizedBox(
//       height: 80,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: images.length,
//         itemBuilder: (context, index) {
//           return Stack(
//             alignment: Alignment.topRight,
//             children: [
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 5),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: kIsWeb
//                       ? Image.memory(images[index].bytes!, width: 70, height: 70, fit: BoxFit.cover)
//                       : Image.file(File(images[index].path!), width: 70, height: 70, fit: BoxFit.cover),
//                 ),
//               ),
//               Positioned(
//                 right: 0,
//                 top: 0,
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       images.removeAt(index);
//                     });
//                   },
//                   child: CircleAvatar(
//                     radius: 10,
//                     backgroundColor: Colors.red,
//                     child: Icon(Icons.close, size: 12, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
