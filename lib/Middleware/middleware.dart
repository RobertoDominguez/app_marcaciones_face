import 'package:app_marcaciones_face/Presentation/biometrico/auth_biometrico.dart';
import 'package:app_marcaciones_face/Presentation/biometrico/faces.dart';
import 'package:flutter/material.dart';
import '../Presentation/Configuracion/configurar.dart';
import '../Presentation/menu.dart';
import '../Session/ConfiguracionSession.dart';
import '../route_generator.dart';

bool auth(){
  return ConfiguracionSession.configuracion.servidor!='';
}

bool guest(){
  return ConfiguracionSession.configuracion.servidor=='';
}

bool authBiometrico(){
  return ConfiguracionSession.configuracion.configurando;
}

bool guestBiometrico(){
  return !ConfiguracionSession.configuracion.configurando;
}

Future<void> loadMiddleware()async{
  await ConfiguracionSession.getSession();
}

Route middleware({required List<String> guards, required Widget builder, required RouteSettings settings}) {

  bool authenticated=true;
  String stopIn='';

  //pone en no configurando biometrico si es que es cualquier ruta no relacionada con biometrico
  if (!guards.contains('biometrico') && !guards.contains('guestBiometrico')){
    ConfiguracionSession.cerrarBiometrico();
  }

  guards.forEach((guard) {
    if (authenticated){
      stopIn=guard;
      //AUTH
      if (guard=='auth'){
        authenticated=auth();
      }
      //GUEST
      if (guard=='guest'){
        authenticated=guest();
      }

      //BIOMETRICO
      if (guard=='biometrico'){
        authenticated=authBiometrico();
      }

      //GUEST BIOMETRICO
      if (guard=='guestBiometrico'){
        authenticated=guestBiometrico();
      }

      //OTHER
    }

  });


  //REDIRECT IF AUTHENTICATED
  if (stopIn=='guest' && !authenticated){
    RouteSettings routeSettings=RouteSettings(name: menuRoute,arguments: settings.arguments);
    return MaterialPageRoute(settings: routeSettings, builder: (context) => const Menu());
    //return const Menu();
  }

  //AUTHENTICATE
  if (stopIn=='auth' && !authenticated){
    RouteSettings routeSettings=RouteSettings(name: configurarRoute,arguments: settings.arguments);
    return MaterialPageRoute(settings: routeSettings, builder: (context) => const Configurar());
  }

  //REDIRECT IF AUTHENTICATED
  if (stopIn=='guestBiometrico' && !authenticated){
    RouteSettings routeSettings=RouteSettings(name: facesRoute,arguments: settings.arguments);
    return MaterialPageRoute(settings: routeSettings, builder: (context) => const FacesIndex());
  }

  //AUTHENTICATE
  if (stopIn=='biometrico' && !authenticated){
    RouteSettings routeSettings=RouteSettings(name: authBiometricoRoute,arguments: settings.arguments);
    return MaterialPageRoute(settings: routeSettings, builder: (context) => const AuthBiometrico());
  }

  //CONTINUE
  return MaterialPageRoute(settings: settings, builder: (context) => builder);
}