import 'package:app_marcaciones_face/env.dart';

import '../Data/DataResponse.dart';
import '../../Data/ConfiguracionData.dart';
import '../../Entities/Configuracion.dart';
import '../../Session/ConfiguracionSession.dart';


class ConfiguracionBusiness{
  ConfiguracionData configuracionData = ConfiguracionData();

  Future<DataResponse> configurar(String host, String codigoSucursal, String codigoPersona, String usuario, String clave) async{
    DataResponse response=await configuracionData.configurar(apiKey, host,codigoSucursal,codigoPersona,usuario,clave);
    if (response.status){
      Configuracion configuracion = response.data;
      await ConfiguracionSession.setSession(configuracion);
    }
    return response;
  }

}