import 'dart:io';

import 'package:flutter/material.dart';
import '../Middleware/middleware.dart';
import '../Presentation/404.dart';
import 'route_generator.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await loadMiddleware();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPB Marcaciones',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: logoRoute,
      onGenerateRoute: RouteGenerator.generateRoute,
      onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => const Error404()
              //settings.name
      ),
    );
  }
}

