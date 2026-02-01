import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_marcaciones_face/Business/FichadaBusiness.dart';
import 'package:app_marcaciones_face/Data/DataResponse.dart';
import 'package:app_marcaciones_face/Session/ConfiguracionSession.dart';
import 'package:app_marcaciones_face/route_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../../Business/BiometricoBusiness.dart';
import '../../Entities/ImageData.dart';
import '../../assets/widgets/buttons.dart';
import '../../assets/widgets/dialog.dart';
import '../../assets/widgets/styles.dart';
import '../Layouts/header.dart';
import '../../assets/widgets/headers.dart';

import 'package:geolocator/geolocator.dart';

class VerificacionBiometrica extends StatefulWidget {
  const VerificacionBiometrica({Key? key}) : super(key: key);

  @override
  State<VerificacionBiometrica> createState() =>
      _VerificacionBiometricaState();
}

class _VerificacionBiometricaState extends State<VerificacionBiometrica> {
  CameraController? _controller;
  bool _initialized = false;
  bool _capturing = false;

  List<ImageData> images = [];
  BiometricoBusiness biometricoBusiness = BiometricoBusiness();
  FichadaBusiness fichadaBusiness = FichadaBusiness();


  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;


  final int captureCount = 1;        // 1..3
  final int captureIntervalMs = 500;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // 👉 Preferir cámara frontal
      final frontIndex = cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );

      selectedCameraIndex = frontIndex != -1 ? frontIndex : 0;

      await _startCamera();
    } catch (e) {
      showAlertDialogMessage(context, "Error", "No se pudo iniciar la cámara");
    }
  }

  Future<void> _startCamera() async {
    _controller?.dispose();

    _controller = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();

    setState(() {
      _initialized = true;
    });
  }

  Future<void> _switchCamera() async {
    if (cameras.length < 2) return;

    selectedCameraIndex =
        (selectedCameraIndex + 1) % cameras.length;

    setState(() {
      _initialized = false;
    });

    await _startCamera();
  }




  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style().backgroundColor(),
      appBar: headerAppBarBack(
        context,
        titulo(context, "VERIFICACIÓN BIOMÉTRICA"),
      ),
      drawer: SideNav(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Mire a la cámara y presione el botón",
                style: TextStyle(
                  color: Style().textColorPrimary(),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              Expanded(
                child: !_initialized
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: !_initialized
                            ? Center(child: CircularProgressIndicator())
                            : Stack(
                                children: [
                                  CameraPreview(_controller!),

                                  Positioned(
                                    top: 15,
                                    right: 15,
                                    child: FloatingActionButton(
                                      mini: true,
                                      backgroundColor: Colors.black54,
                                      onPressed: _switchCamera,
                                      child: Icon(Icons.cameraswitch),
                                    ),
                                  ),
                                ],
                              ),
                      ),

              ),

              SizedBox(height: 10),
              // _buildPreview(),

              SizedBox(height: 20),

              _capturing
                  ? Text(
                      "Capturando imágenes...",
                      style: TextStyle(color: Style().textColorPrimary()),
                    )
                  : buttonPrimary(
                      context,
                      "Verificar identidad",
                      startAutomaticCapture,
                    ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }

  /// --------------------------------------
  /// Captura automática en ráfaga
  /// --------------------------------------
  Future<void> startAutomaticCapture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() {
      images.clear();
      _capturing = true;
    });

    for (int i = 0; i < captureCount; i++) {
      try {
        final XFile file = await _controller!.takePicture();

        if (kIsWeb) {
          Uint8List bytes = await file.readAsBytes();
          images.add(ImageData(bytes: bytes));
        } else {
          images.add(ImageData(path: file.path));
        }

        setState(() {});
        await Future.delayed(Duration(milliseconds: captureIntervalMs));
      } catch (e) {
        break;
      }
    }

    setState(() => _capturing = false);
    verifyIdentity();
  }

  /// --------------------------------------
  /// Verificación biométrica
  /// --------------------------------------
  Future<void> verifyIdentity() async {
    if (images.length != captureCount) {
      showAlertDialogMessage(context, "Error", "Captura incompleta");
      return;
    }

    try {
      showLoadingIndicator(context, "Verificando identidad...");

      final response = await biometricoBusiness.recognize(images);

      hideOpenDialog(context);

      if (!response.status) {
        showAlertDialog(context, "No reconocido", response.message);
        return;
      }

      var confidence = response.data['confidence'];

      showLoadingIndicator(context, 'Registrando Marcado Remoto...');

      String ip = 'WEB';

      Position position = await _determinePosition();
      ip = '${toDMS(position.latitude.abs())}|${toDMS(position.longitude.abs())}|${position.latitude}|${position.longitude}';

      String fecha = formatoDateTime();

      print(position.latitude);
      print(position.longitude);

      DataResponse dataResponse = await fichadaBusiness.store(ConfiguracionSession.configuracion.idSucursal,response.data['code'],fecha,'Biometrico',ip,'','0',position.latitude,position.longitude,[]);

      hideOpenDialog(context);

      if (dataResponse.status) {
        showAlertDialogContinue(
          context,
          "Guardado con exito!",
          dataResponse.message,
          () {
            if (ConfiguracionSession.configuracion.codigoPersona != ''){
              Navigator.pushReplacementNamed(context, menuRoute); 
            }
          },
        );
      } else {
        showAlertDialog(
          context,
          "Error al guardar Marcado Remoto",
          dataResponse.message,
        );
      }

    } catch (e) {
      hideOpenDialog(context);
      showAlertDialogMessage(context, "Error", e.toString());
    }
  }

  /// --------------------------------------
  /// Preview imágenes
  /// --------------------------------------
  Widget _buildPreview() {
    if (images.isEmpty) return Container();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (_, i) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: kIsWeb
                  ? Image.memory(images[i].bytes!,
                      width: 70, height: 70, fit: BoxFit.cover)
                  : Image.file(File(images[i].path!),
                      width: 70, height: 70, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
  

  /// ==========================
  /// UTILS
  /// ==========================
  String formatoDateTime() {
    DateTime now = DateTime.now();
    return '${now.year}-${now.month}-${now.day} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
  }

  String toDMS(double dato) {
    String d = parteEntera(dato.toString());
    String clock1 =
        (double.parse('0.${parteDecimal(dato.toString())}') * 60).toString();
    String m = parteEntera(clock1);
    String clock2 =
        (double.parse('0.${parteDecimal(clock1)}') * 60).toString();
    String s = double.parse(clock2).toStringAsFixed(2);
    return '$d°$m\'$s"';
  }

  String parteEntera(String dato) =>
      dato.substring(0, dato.indexOf("."));

  String parteDecimal(String dato) =>
      dato.substring(dato.indexOf(".") + 1);

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Servicios de localizacion desactivados.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permisos de localizacion denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Permisos de ubicación permanentemente denegados',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

}
