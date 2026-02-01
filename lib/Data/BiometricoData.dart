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

}

  // Future<DataResponse> store(String token,Fichada fichada,String host) async{
  //   DataResponse dataResponse=new DataResponse();
  //   try {

  //     var url = Uri.parse(host+'/api/fichadas/fichada');
  //     var request = http.MultipartRequest("POST",url);
  //     request.headers['Accept']='application/json';
  //     request.headers['appToken']=token;
  //     fichada.toMapStore().forEach((key, value) {
  //       request.fields[key]=value;
  //     });


  //     if (fichada.foto!=null){

  //       if (!kIsWeb && fichada.foto!='') {
  //         bool existeFoto=await File(fichada.foto).exists();
  //         if ( existeFoto){
  //           var status = await Permission.storage.status;
  //           if (!status.isGranted) {
  //             await Permission.storage.request();
  //           }
  //           File fotoFile=new File(fichada.foto);
  //           http.ByteStream streamfoto = new http.ByteStream(DelegatingStream.typed(fotoFile.openRead()));
  //           int lengthfoto = await fotoFile.length();
  //           var multipartFilefoto = new http.MultipartFile('foto', streamfoto, lengthfoto,filename: basename(fotoFile.path));
  //           request.files.add(multipartFilefoto);
  //         }

  //       }

  //     }


  //     if (fichada.foto2!=null){

  //       if (!kIsWeb && fichada.foto2!='') {
  //         bool existeFoto=await File(fichada.foto2).exists();
  //         if ( existeFoto){
  //           var status = await Permission.storage.status;
  //           if (!status.isGranted) {
  //             await Permission.storage.request();
  //           }
  //           File fotoFile2=new File(fichada.foto2);
  //           http.ByteStream streamfoto2 = new http.ByteStream(DelegatingStream.typed(fotoFile2.openRead()));
  //           int lengthfoto2 = await fotoFile2.length();
  //           var multipartFilefoto2 = new http.MultipartFile('foto2', streamfoto2, lengthfoto2,filename: basename(fotoFile2.path));
  //           request.files.add(multipartFilefoto2);
  //         }

  //       }

  //     }

  //     if (fichada.foto3!=null){

  //       if (!kIsWeb && fichada.foto3!='') {
  //         bool existeFoto=await File(fichada.foto3).exists();
  //         if ( existeFoto){
  //           var status = await Permission.storage.status;
  //           if (!status.isGranted) {
  //             await Permission.storage.request();
  //           }
  //           File fotoFile3=new File(fichada.foto3);
  //           http.ByteStream streamfoto3 = new http.ByteStream(DelegatingStream.typed(fotoFile3.openRead()));
  //           int lengthfoto3 = await fotoFile3.length();
  //           var multipartFilefoto3 = new http.MultipartFile('foto3', streamfoto3, lengthfoto3,filename: basename(fotoFile3.path));
  //           request.files.add(multipartFilefoto3);
  //         }

  //       }

  //     }


  //     var response = await request.send();
  //     var responseData = await response.stream.toBytes();
  //     var result = String.fromCharCodes(responseData);

  //     if (kDebugMode) {
  //       print(result);
  //     }
  //     const JsonDecoder decoder = const JsonDecoder();
  //     var item = decoder.convert(result);
  //     if (response.statusCode == 200) {

  //       var element=item['data'];

  //       Fichada fichada=new Fichada();
  //       fichada.id=element['id'].toString();
  //       fichada.codigo=element['codigo'].toString();
  //       fichada.fecha=element['fecha'].toString();
  //       fichada.hostname=element['hostname'].toString();
  //       fichada.ip=element['ip'].toString();


  //       dataResponse.data=fichada;
  //       dataResponse.status=true;
  //     }
  //     dataResponse.message=item['message'];
  //   }catch(error){
  //     if (kDebugMode) {
  //       print(error.toString());
  //     }
  //     dataResponse.message=error.toString();
  //   }
  //   return dataResponse;
  // }


// }


