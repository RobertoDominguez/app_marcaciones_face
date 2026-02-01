import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import '../Data/DataResponse.dart';
import '../Entities/Fichada.dart';


class FichadaData {

  Future<DataResponse> store(String apiKey,Fichada fichada,String host,lat,long) async {
    DataResponse dataResponse = DataResponse();

    try {
      var url = Uri.parse('$host/api/fichada/store');
      var request = http.MultipartRequest("POST", url);

      request.headers['Accept'] = 'application/json';
      request.headers['apiKey'] = apiKey;

      fichada.toMapStore().forEach((key, value) {
        request.fields[key] = value;
      });
      request.fields['lat'] = lat.toString();
      request.fields['long'] = long.toString();

      /// ===============================
      /// IMÁGENES (foto, foto2, foto3)
      /// ===============================
      for (int i = 0; i < fichada.images.length && i < 3; i++) {
        final img = fichada.images[i];
        final fieldName = 'foto${i == 0 ? '' : i + 1}';

        if (kIsWeb && img.bytes != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              fieldName,
              img.bytes!,
              filename: '$fieldName.jpg',
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }

        if (!kIsWeb && img.path != null && img.path!.isNotEmpty) {
          File file = File(img.path!);
          if (await file.exists()) {
            request.files.add(
              await http.MultipartFile.fromPath(
                fieldName,
                file.path,
                filename: basename(file.path),
              ),
            );
          }
        }
      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var result = String.fromCharCodes(responseData);

      if (kDebugMode) {
        print(result);
      }

      final item = jsonDecode(result);

      if (response.statusCode == 200) {
        var element = item['data'];

        Fichada f = Fichada();
        f.id = element['id'].toString();
        f.codigo = element['codigo'].toString();
        f.fecha = element['fecha'].toString();
        f.hostname = element['hostname'].toString();
        f.ip = element['ip'].toString();

        dataResponse.status = true;
        dataResponse.data = f;
      }

      dataResponse.message = item['message'].toString();

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      dataResponse.message = e.toString();
    }

    return dataResponse;
  }
}
