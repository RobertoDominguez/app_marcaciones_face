import 'package:app_marcaciones_face/Entities/ImageData.dart';
import 'package:app_marcaciones_face/Session/ConfiguracionSession.dart';
import 'package:app_marcaciones_face/env.dart';

import '../Data/DataResponse.dart';
import '../../Data/BiometricoData.dart';


class BiometricoBusiness{
  BiometricoData biometricoData = BiometricoData();

  Future<DataResponse> faces() async{
    DataResponse response = await biometricoData.faces(apiKeyBiometrico, ConfiguracionSession.configuracion.dbBiometrico);
    return response;
  }

  Future<DataResponse> register(String code,images) async{
    DataResponse response = await biometricoData.register(apiKeyBiometrico, ConfiguracionSession.configuracion.dbBiometrico, code,images);
    return response;
  }

  Future<DataResponse> recognize(List<ImageData> images) async{
    DataResponse response = await biometricoData.recognize(apiKeyBiometrico, ConfiguracionSession.configuracion.dbBiometrico,images);
    return response;
  }

  Future<DataResponse> delete(String code) async{
    DataResponse response = await biometricoData.delete(apiKeyBiometrico, ConfiguracionSession.configuracion.dbBiometrico,code);
    return response;
  }

}