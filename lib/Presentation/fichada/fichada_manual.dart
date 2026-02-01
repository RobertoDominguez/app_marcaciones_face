import 'dart:io';

import 'package:app_marcaciones_face/Entities/ImageData.dart';
import 'package:app_marcaciones_face/assets/widgets/imagepick_service.dart';
import 'package:app_marcaciones_face/env.dart';
import 'package:app_marcaciones_face/route_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../../Business/FichadaBusiness.dart';
import '../../Data/DataResponse.dart';
import '../../Session/ConfiguracionSession.dart';
import '../../assets/widgets/buttons.dart';
import '../../assets/widgets/dialog.dart';
import '../../assets/widgets/headers.dart';
import '../../assets/widgets/inputs.dart';
import '../../assets/widgets/styles.dart';
import '../../assets/widgets/texts.dart';
import '../Layouts/header.dart';

class GuardarFichadaManual extends StatefulWidget {
  const GuardarFichadaManual({super.key});

  @override
  State<StatefulWidget> createState() => __GuardarFichadaManualState();
}

class __GuardarFichadaManualState extends State<GuardarFichadaManual> {
  final _formKey = GlobalKey<FormState>();
  bool isInitState = true;

  final controllerObservacion = TextEditingController();
  final controllerCodigo = TextEditingController();

  String hostname = 'FICHADA MANUAL';
  String observacion = '';

  final int maxImages = 3;
  List<ImageData> images = [];

  FichadaBusiness fichadaBusiness = FichadaBusiness();

  @override
  Widget build(BuildContext context) {
    if (isInitState) {
      isInitState = false;

      controllerObservacion.addListener(() {
        observacion = controllerObservacion.text;
      });

      controllerCodigo.text =
          ConfiguracionSession.configuracion.codigoPersona ?? '';
    }

    return Scaffold(
      backgroundColor: Style().backgroundColor(),
      appBar: headerAppBarBack(context, titulo(context, "GUARDAR MARCADO      ")),
      drawer: SideNav(),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: todo(context),
          ),
        ),
      ),
    );
  }

  Widget todo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Image.asset("${assetURL}acceso_remoto.png", alignment: Alignment.center, height: 70, width: 70,),
                SizedBox(height: 20.0),
          customText(context, Icon(Icons.home, color: Colors.white), hostname),
          SizedBox(height: 10),

          /// INPUT CODIGO
          CustomInputField( Icon(Icons.badge, color: Colors.white), "CODIGO PERSONA", controllerCodigo, false,TextInputType.number,
                  <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  (value) {
                  if (value == null || value.isEmpty) {
                      return "Ingrese el código";
                    }
                    return null;
                  },1,0,ConfiguracionSession.configuracion.codigoPersona != ''
                  
          ),

          SizedBox(height: 15),

          CustomInputField(
            Icon(Icons.message, color: Colors.white),
            "OBSERVACION (OPCIONAL)",
            controllerObservacion,
            false,
            TextInputType.multiline,
            const [],
            (value) => null,
            2,
          ),

          SizedBox(height: 20),

          /// BOTON AGREGAR FOTO
          buttonPrimary(
            context,
            "Agregar Foto (${images.length}/$maxImages)",
            takePhoto,
          ),

          SizedBox(height: 10),

          /// PREVIEW
          buildImagePreview(),

          SizedBox(height: 40),

          buttonSeccondary(context, "Guardar", storeFichada),
        ],
      ),
    );
  }

  /// ==========================
  /// TOMAR FOTO (WEB + MOBILE)
  /// ==========================
  Future<void> takePhoto() async {
    if (images.length >= maxImages) {
      showAlertDialogMessage(
        context,
        "Aviso",
        "Máximo $maxImages fotos permitidas",
      );
      return;
    }

    final ImageData? result = await pickImageUniversal();
    if (result == null) return;

    setState(() {
      images.add(result);
    });
  }

  /// PICK UNIVERSAL
  Future<ImageData?> pickImageUniversal() async {
    final result = await ImagePickerService.pickImage();
    if (result == null) return null;

    return ImageData(
      path: result.path,
      bytes: result.bytes,
    );
  }

  /// PREVIEW
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
                      ? Image.memory(
                          images[index].bytes!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(images[index].path!),
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
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

  /// ==========================
  /// GUARDAR FICHADA
  /// ==========================
  Future<void> storeFichada() async {
    try {
      if (_formKey.currentState!.validate()) {
        showLoadingIndicator(context, 'Registrando Marcado Remoto...');

        String ip = 'WEB';
        if (!kIsWeb) {

        }

          Position position = await _determinePosition();
          ip = '${toDMS(position.latitude.abs())}|${toDMS(position.longitude.abs())}|${position.latitude}|${position.longitude}';

        String fecha = formatoDateTime();
        String codigo = controllerCodigo.text;

        DataResponse dataResponse = await fichadaBusiness.store(ConfiguracionSession.configuracion.idSucursal,codigo,fecha,hostname,ip,observacion,'1',position.latitude,position.longitude,images);

        hideOpenDialog(context);

        if (dataResponse.status) {
          showAlertDialogContinue(
            context,
            "Guardado con exito!",
            dataResponse.message,
            () {
              Navigator.pushReplacementNamed(context, menuRoute);
            },
          );
        } else {
          showAlertDialog(
            context,
            "Error al guardar Marcado Remoto",
            dataResponse.message,
          );
        }
      }
    } catch (e) {
      hideOpenDialog(context);
      showAlertDialogMessage(context, 'Error', e.toString());
    }
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
