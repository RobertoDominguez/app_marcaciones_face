import 'dart:convert';

import '../Data/DataResponse.dart';
import '../Entities/Configuracion.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';

class ConfiguracionData{


  Future<DataResponse> configurar(String apiKey, String host, String codigoSucursal, String codigoPersona, String usuario, String clave) async{
    DataResponse dataResponse=DataResponse();
    try{

      if (host.endsWith('/')){
        host = host.substring(0,host.length-1);
      }

      var url = Uri.parse('$host/api/configurar');
      final http.Response response = await http.post(url,
          headers: { 'Accept' : 'application/json', 'apiKey' : apiKey },
          body: {'codigo_sucursal': codigoSucursal, 'codigo_persona': codigoPersona, 'usuario' : usuario , 'clave' : clave});
      
      if (kDebugMode) {
        print(response.body);
      }
      const JsonDecoder decoder = JsonDecoder();
      var item = decoder.convert(response.body);

      if (response.statusCode == 200) {
        var data=item['data'];

        Configuracion configuracion = Configuracion();
        configuracion.servidor=host;
        configuracion.idSucursal=data['idSucursal'].toString();
        configuracion.codigoSucursal=data['codigoSucursal'].toString();
        configuracion.nombreSucursal=data['nombreSucursal'].toString();
        configuracion.codigoPersona=data['codigoPersona'].toString();
        configuracion.nombresPersona=data['nombresPersona'].toString();
        configuracion.apellidosPersona=data['apellidosPersona'].toString();
        configuracion.dbBiometrico=data['DB'].toString();


        dataResponse.data=configuracion;
        dataResponse.status=true;
      }
      dataResponse.message=item['message'].toString();
    }catch(error){
      if (kDebugMode) {
        print(error.toString());
      }
      dataResponse.message=error.toString();
    }
    return dataResponse;
  }



}