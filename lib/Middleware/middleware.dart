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

Future<void> loadMiddleware()async{
  await ConfiguracionSession.getSession();
}

Route middleware({required List<String> guards, required Widget builder, required RouteSettings settings}) {

  bool authenticated=true;
  String stopIn='';

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
  //CONTINUE
  return MaterialPageRoute(settings: settings, builder: (context) => builder);
}