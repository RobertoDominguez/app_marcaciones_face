import 'package:app_marcaciones_face/Presentation/404.dart';
import 'package:app_marcaciones_face/Presentation/biometrico/auth_biometrico.dart';
import 'package:app_marcaciones_face/Presentation/biometrico/faces.dart';
import 'package:app_marcaciones_face/Presentation/biometrico/new_face.dart';
import 'package:app_marcaciones_face/Presentation/fichada/fichada_face.dart';
import 'package:app_marcaciones_face/Presentation/fichada/fichada_manual.dart';
import 'package:flutter/material.dart';
import '../Presentation/Configuracion/configurar.dart';
import '../Presentation/logo.dart';
import '../Middleware/middleware.dart';

import '../Presentation/menu.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    // final args=settings.arguments;

    String name=settings.name?? "";
    var requests=request(name);

    if (requests.isNotEmpty){
      name=name.split("?")[0];
    }

    switch (name){
      case menuRoute:
        return middleware(guards: [], builder: const Menu(), settings: settings);
      case logoRoute:
        return middleware(guards: [], builder: const Logo(), settings: settings);
      case configurarRoute:
        return middleware(guards: [], builder: const Configurar(), settings: settings);

      case guardarFichadaManualRoute:
        return middleware(guards: ['auth'], builder: const GuardarFichadaManual(), settings: settings);
      case verificacionBiometricaRoute:
        return middleware(guards: ['auth'], builder: const VerificacionBiometrica(), settings: settings);

      case authBiometricoRoute:
        return middleware(guards: ['auth','guestBiometrico'], builder: const AuthBiometrico(), settings: settings);
      case facesRoute:
        return middleware(guards: ['auth','authBiometrico'], builder: const FacesIndex(), settings: settings);
      case registrarFaceRoute:
        return middleware(guards: ['auth','authBiometrico'], builder: const RegistroBiometrico(), settings: settings);

      default:
        RouteSettings routeSettings=RouteSettings(name: menuRoute,arguments: settings.arguments);
        return MaterialPageRoute(settings: routeSettings, builder: (context) => const Menu());
    }
  }

  static Map<String,String> request(String name){

    Map<String,String> result={};
    if (name.split("?").length==2){
      List<String> queries=name.split("?")[1].split("&&");

      queries.forEach((element) {
        List map=element.split("=");
        if (map.length==2){
          result[map[0]]=map[1];
        }
      });
    }
    return result;
  }
}

const logoRoute = '/logo';

const configurarRoute = '/configurar';

const menuRoute = '/menu';

const verificacionBiometricaRoute = '/fichada/verificacion_biometrica';
const guardarFichadaManualRoute = '/fichada/guardar_manual';

const authBiometricoRoute = '/biometrico/auth';
const facesRoute = '/biometrico/personas';
const registrarFaceRoute = '/biometrico/registrar';

//        settings=RouteSettings(name: 'test');