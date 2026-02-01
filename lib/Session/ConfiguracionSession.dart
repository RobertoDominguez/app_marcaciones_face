// ignore: file_names
import '../Entities/Configuracion.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class ConfiguracionSession{
  static final ConfiguracionSession _instance = ConfiguracionSession._internal();
  factory ConfiguracionSession() => _instance;

  static Configuracion configuracion = Configuracion();

  ConfiguracionSession._internal() {
    // init things inside this
  }

  static ConfiguracionSession get shared => _instance;

  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<void> getSession()async{
    final SharedPreferences prefs = await _prefs;

    configuracion.servidor=prefs.getString('servidor') ?? '';
    configuracion.idSucursal=prefs.getString('idSucursal') ?? '';
    configuracion.codigoSucursal=prefs.getString('codigoSucursal') ?? '';
    configuracion.nombreSucursal=prefs.getString('nombreSucursal') ?? '';
    configuracion.codigoPersona=prefs.getString('codigoPersona') ?? '';
    configuracion.nombresPersona=prefs.getString('nombresPersona') ?? '';
    configuracion.apellidosPersona = prefs.getString('apellidosPersona') ?? '';
    configuracion.dbBiometrico = prefs.getString('dbBiometrico') ?? '';

  }

  static Future<void> setSession(Configuracion configuracionP)async{
    final SharedPreferences prefs = await _prefs;

    await prefs.setString('servidor', configuracionP.servidor);
    await prefs.setString('idSucursal', configuracionP.idSucursal);
    await prefs.setString('codigoSucursal', configuracionP.codigoSucursal);
    await prefs.setString('nombreSucursal', configuracionP.nombreSucursal);
    await prefs.setString('codigoPersona', configuracionP.codigoPersona);
    await prefs.setString('nombresPersona', configuracionP.nombresPersona);
    await prefs.setString('apellidosPersona', configuracionP.apellidosPersona);
    await prefs.setString('dbBiometrico', configuracionP.dbBiometrico);

    ConfiguracionSession.configuracion = configuracionP;
  }
}