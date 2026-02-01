import 'dart:io';
import 'package:app_marcaciones_face/Entities/ImageData.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'package:face_camera/face_camera.dart';
import '../../Business/BiometricoBusiness.dart';
import '../../assets/widgets/buttons.dart';
import '../../assets/widgets/dialog.dart';
import '../../assets/widgets/inputs.dart';
import '../../assets/widgets/styles.dart';
import '../Layouts/header.dart';
import '../../assets/widgets/headers.dart';


class RegistroBiometrico extends StatefulWidget {
  const RegistroBiometrico({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegistroBiometricoState();
}

class _RegistroBiometricoState extends State<RegistroBiometrico> {
  final _formKey = GlobalKey<FormState>();
  final controllerCode = TextEditingController();
  List<ImageData> images = [];
  bool isMobile = !kIsWeb;

  BiometricoBusiness biometricoBusiness = BiometricoBusiness();

  @override
  void dispose() {
    controllerCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style().backgroundColor(),
      appBar: headerAppBarBack(context,titulo(context, "REGISTRO BIOMÉTRICO      ")),
      drawer: SideNav(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CustomInputField(
                  Icon(Icons.code, color: Colors.white),
                  "Código",
                  controllerCode,
                  false,
                  TextInputType.text,
                  [],
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingrese un código";
                    }
                    return null;
                  },
                  1,
                ),
                SizedBox(height: 20),
                Expanded(child: buildCameraWidget()),
                SizedBox(height: 10),
                buildImagePreview(),
                SizedBox(height: 20),
                Text(
                  "Fotos tomadas: ${images.length}/5",
                  style: TextStyle(color: Style().textColorPrimary(),fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                buttonSeccondary(context, "Registrar", registerBiometrico),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCameraWidget() {
    if (isMobile) {
      return Expanded(
              child: MobileCameraWidget(
                maxImages: 5,
                minImages: 3,
                onImage: (imagePath) {
                  if (images.length < 5) {
                    setState(() {
                      images.add(ImageData(path: imagePath));
                    });
                  } else {
                    showAlertDialogMessage(context, "Aviso", "Máximo 5 fotos permitidas");
                  }
                },
              ),
            );
    } else {
      return WebCameraWidget(
        onImage: (imageData) {
          if (images.length < 5) {
            setState(() {
              images.add(imageData);
            });
          } else {
            showAlertDialogMessage(context, "Aviso", "Máximo 5 fotos permitidas");
          }
        },
        minImages: 3,
      );
    }
  }

  Widget buildImagePreview() {
    if (images.isEmpty) return Container();
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: kIsWeb
                      ? Image.memory(images[index].bytes!, width: 70, height: 70, fit: BoxFit.cover)
                      : Image.file(File(images[index].path!), width: 70, height: 70, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      images.removeAt(index);
                    });
                  },
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, size: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> registerBiometrico() async {
    if (_formKey.currentState!.validate()) {
      // Validar mínimo de fotos
      if (images.length < 3) {
        showAlertDialogMessage(context, "Error", "Debe tomar al menos 3 fotos");
        return;
      }

      String code = controllerCode.text.trim();

      try {
        // Mostrar indicador de carga
        showLoadingIndicator(context, "Registrando Biometría...");

        // Llamar al método register de BiometricoBusiness
        var response = await biometricoBusiness.register(code,images);

        // Ocultar indicador
        hideOpenDialog(context);

        if (response.status) {
          showAlertDialogContinue(context, "Éxito", "Biometría registrada correctamente", () {
            Navigator.pop(context,true);
          });
        } else {
          showAlertDialog(context, "Error", response.message);
        }
      } catch (e) {
        hideOpenDialog(context);
        showAlertDialogMessage(context, "Error", e.toString());
      }
    }
  }

}







/// --------------------------------------
/// Web Camera Widget
/// --------------------------------------
class WebCameraWidget extends StatefulWidget {
  final Function(ImageData imageData) onImage;
  final int minImages;

  const WebCameraWidget({
    Key? key,
    required this.onImage,
    this.minImages = 3,
  }) : super(key: key);

  @override
  State<WebCameraWidget> createState() => _WebCameraWidgetState();
}


class _WebCameraWidgetState extends State<WebCameraWidget> {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    initCamera(front: true);
  }

  Future<void> initCamera({bool front = true}) async {
    cameras = await availableCameras();

    selectedCameraIndex = cameras.indexWhere(
      (c) => c.lensDirection == (front ? CameraLensDirection.front : CameraLensDirection.back),
    );

    if (selectedCameraIndex == -1) selectedCameraIndex = 0;

    controller?.dispose();
    controller = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller!.initialize();
    setState(() {});
  }

  void switchCamera() {
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    initCamera(
      front: cameras[selectedCameraIndex].lensDirection == CameraLensDirection.front,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(controller!),

              Positioned(
                top: 12,
                right: 12,
                child: FloatingActionButton(
                  mini: true,
                  heroTag: "switch_web",
                  backgroundColor: Colors.black54,
                  onPressed: switchCamera,
                  child: const Icon(Icons.cameraswitch),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        buttonPrimary(context, "Tomar Foto", () async {
          try {
            final file = await controller!.takePicture();
            final bytes = await file.readAsBytes();
            widget.onImage(ImageData(path: file.path, bytes: bytes));
          } catch (_) {
            showAlertDialogMessage(context, "Error", "No se pudo tomar la foto");
          }
        }),
      ],
    );
  }
}




class MobileCameraWidget extends StatefulWidget {
  final Function(String imagePath) onImage;
  final int maxImages;
  final int minImages;

  const MobileCameraWidget({
    Key? key,
    required this.onImage,
    this.maxImages = 5,
    this.minImages = 3,
  }) : super(key: key);

  @override
  State<MobileCameraWidget> createState() => _MobileCameraWidgetState();
}

class _MobileCameraWidgetState extends State<MobileCameraWidget> {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    initCamera(front: true);
  }

  Future<void> initCamera({bool front = true}) async {
    cameras = await availableCameras();

    selectedCameraIndex = cameras.indexWhere(
      (c) => c.lensDirection == (front ? CameraLensDirection.front : CameraLensDirection.back),
    );

    if (selectedCameraIndex == -1) selectedCameraIndex = 0;

    controller?.dispose();
    controller = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller!.initialize();
    setState(() {});
  }

  void switchCamera() {
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    initCamera(
      front: cameras[selectedCameraIndex].lensDirection == CameraLensDirection.front,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(controller!),

              Positioned(
                top: 12,
                right: 12,
                child: FloatingActionButton(
                  mini: true,
                  heroTag: "switch_mobile",
                  backgroundColor: Colors.black54,
                  onPressed: switchCamera,
                  child: const Icon(Icons.cameraswitch),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        buttonPrimary(context, "Tomar Foto", () async {
          try {
            final file = await controller!.takePicture();
            widget.onImage(file.path);
          } catch (e) {
            showAlertDialogMessage(context, "Error", "No se pudo tomar la foto");
          }
        }),
      ],
    );
  }
}
