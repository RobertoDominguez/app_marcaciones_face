import 'dart:convert';

import 'package:app_marcaciones_face/env.dart';

import '../Data/DataResponse.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';











import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../Entities/ImageData.dart'; // la clase que definimos antes
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';






class BiometricoData {

  Future<DataResponse> faces(String apiKey, String db) async {
    DataResponse dataResponse = DataResponse();
    try {
      var url = Uri.parse('$hostBiometrico/faces?db=$db');
      final http.Response response = await http.get(
        url,
        headers: {'Accept': 'application/json', 'apiKey': apiKey},
      );

      if (kDebugMode) {
        print(response.body);
      }
      const JsonDecoder decoder = JsonDecoder();
      var item = decoder.convert(response.body);

      dataResponse.message = 'Error al obtener datos del biometrico';
      if (response.statusCode == 200) {
        List<String> items = [];
        Map faces = item['faces'];

        faces.forEach((codigo, faces) {
          String c = codigo;
          items.add(c);
        });

        dataResponse.data = items;
        dataResponse.status = true;
        dataResponse.message = 'Datos del biometrico obtenidos correctamente';
      }
      
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      dataResponse.message = error.toString();
    }
    return dataResponse;
  }











  Future<DataResponse> register(String apiKey, String db, String code, List<ImageData> images) async {
    DataResponse dataResponse = DataResponse();

    try {
      var url = Uri.parse('$hostBiometrico/register');
      var request = http.MultipartRequest("POST", url);

      request.headers['Accept'] = 'application/json';
      request.headers['apiKey'] = apiKey;

      request.fields['db'] = db;
      request.fields['code'] = code;

      // Subir las imágenes
      for (int i = 0; i < images.length; i++) {
        String fieldName = 'images';

        if (!kIsWeb) {
          // Mobile: path
          if (images[i].path != null && images[i].path!.isNotEmpty) {
            bool existeFoto = await File(images[i].path!).exists();
            if (existeFoto) {
              var status = await Permission.storage.status;
              if (!status.isGranted) {
                await Permission.storage.request();
              }
              File fotoFile = File(images[i].path!);
              var stream = http.ByteStream(fotoFile.openRead());
              int length = await fotoFile.length();
              var multipartFile = http.MultipartFile(
                fieldName,
                stream,
                length,
                filename: basename(fotoFile.path),
              );
              request.files.add(multipartFile);
            }
          }
        } else {
          // Web: bytes
          if (images[i].bytes != null) {
            var multipartFile = http.MultipartFile.fromBytes(
              fieldName,
              images[i].bytes!,
              filename: 'photo$i.jpg',
            );
            request.files.add(multipartFile);
          }
        }
      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var result = String.fromCharCodes(responseData);

      if (kDebugMode) print(result);

      var item = json.decode(result);

      if (response.statusCode == 200) {
        dataResponse.status = true;
        dataResponse.message = "Registrado correctamente";
        dataResponse.data = item['code'];
      } else {
        dataResponse.status = false;
        dataResponse.message = "Error al registrar biometría";
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
      dataResponse.status = false;
      dataResponse.message = e.toString();
    }

    return dataResponse;
  }





  Future<DataResponse> recognize(String apiKey, String db, List<ImageData> images) async {
    DataResponse dataResponse = DataResponse();

    try {
      var url = Uri.parse('$hostBiometrico/recognize');
      var request = http.MultipartRequest("POST", url);

      request.headers['Accept'] = 'application/json';
      request.headers['apiKey'] = apiKey;

      request.fields['db'] = db;

      // Subir las imágenes
      for (int i = 0; i < images.length; i++) {
        String fieldName = 'images';

        if (!kIsWeb) {
          // Mobile: path
          if (images[i].path != null && images[i].path!.isNotEmpty) {
            bool existeFoto = await File(images[i].path!).exists();
            if (existeFoto) {
              var status = await Permission.storage.status;
              if (!status.isGranted) {
                await Permission.storage.request();
              }
              File fotoFile = File(images[i].path!);
              var stream = http.ByteStream(fotoFile.openRead());
              int length = await fotoFile.length();
              var multipartFile = http.MultipartFile(
                fieldName,
                stream,
                length,
                filename: basename(fotoFile.path),
              );
              request.files.add(multipartFile);
            }
          }
        } else {
          if (images[i].bytes != null) {
            var multipartFile = http.MultipartFile.fromBytes(
              fieldName,
              images[i].bytes!,
              filename: 'photo$i.jpg',
            );
            request.files.add(multipartFile);
          }
        }
      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var result = String.fromCharCodes(responseData);

      if (kDebugMode) print(result);

      var item = json.decode(result);

      if (response.statusCode == 200) {
        dataResponse.status = true;
        dataResponse.message = "Persona reconocida con exito";
        dataResponse.data = item;
      } else {
        dataResponse.status = false;
        // ignore: prefer_interpolation_to_compose_strings
        dataResponse.message = "Error: "+item['detail'];
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
      dataResponse.status = false;
      dataResponse.message = e.toString();
    }

    return dataResponse;
  }








  Future<DataResponse> delete(String apiKey, String db,String code) async {
    DataResponse dataResponse = DataResponse();
    try {
      var url = Uri.parse('$hostBiometrico/faces/$code?db=$db');
      final http.Response response = await http.delete(
        url,
        headers: {'Accept': 'application/json', 'apiKey': apiKey},
      );


      if (kDebugMode) {
        print(response.body);
      }
      const JsonDecoder decoder = JsonDecoder();
      var item = decoder.convert(response.body);

      dataResponse.message = 'Error al eliminar codigo';
      if (response.statusCode == 200) {

        dataResponse.data = code;
        dataResponse.status = true;
        dataResponse.message = 'Codigo $code eliminado correctamente';
      }
      
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      dataResponse.message = error.toString();
    }
    return dataResponse;
  }


}
