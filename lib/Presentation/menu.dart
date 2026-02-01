import 'package:flutter/material.dart';
import '../Presentation/Layouts/header.dart';
import '../Session/ConfiguracionSession.dart';
import '../assets/widgets/headers.dart';
import '../assets/widgets/styles.dart';

// import '../assets/widgets/searchs.dart';
import '../env.dart';
import '../route_generator.dart';

class Menu extends StatefulWidget{
  const Menu({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return __MenuState();
  }

}

class __MenuState extends State<Menu>{

  DateTime currentBackPressTime=DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Style().backgroundColor(),
      appBar: headerAppBar(context,titulo(context, "      ")),
      drawer: SideNav(),
      body: WillPopScope(
        child: SafeArea(
          child: SizedBox.expand(
            child: Stack(
              children: <Widget>[
                //appBackground(),
                SingleChildScrollView(
                  child: todo(context),
                )
              ],
            ),
          ),
        ),
        onWillPop: onWillPop,
      )
    );
  }

  Future<bool> onWillPop() {

    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      _showToast(context);
      return Future.value(false);
    }

    return Future.value(true);
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Presiona una vez mas para salir'),
        //action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
        duration: Duration(seconds: 1),
      ),
    );
  }


  Widget todo(BuildContext context) {
    return
      SafeArea(
          child: Container(
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                cardPersona(context),
                SizedBox(height: 30,),
                cardOpcion(context, 'MARCADO REMOTO', 'escaneo_facial.png', Colors.blue,(){ Navigator.pushNamed(context, verificacionBiometricaRoute); }),
                SizedBox(height: 10,),
                cardOpcion(context, 'MARCADO MANUAL', 'acceso_remoto.png', const Color.fromARGB(255, 255, 101, 40),(){ Navigator.pushNamed(context, guardarFichadaManualRoute); }),
              ],
            ),
          )
      );

  }

  Widget cardPersona(BuildContext context){
    return Card(
      color: const Color.fromARGB(255, 240, 241, 255),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.account_circle,size: 50,),
          ),
          SizedBox(
            height: 25,
            width: MediaQuery.of(context).size.width*0.6,
            child: FittedBox(
                fit: BoxFit.contain,
                child: Text(ConfiguracionSession.configuracion.nombresPersona,style: TextStyle(color: Colors.black),)
            ),
          )

        ],
      ),
    );
  }

  Widget cardOpcion(BuildContext context,String text,String image,Color color,VoidCallback action){
    return GestureDetector(
      child: Card(
        color: color,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Image.asset(assetURL+image,width: 150,height: 150,)
            ),
            SizedBox(
              height: 25,
              width: MediaQuery.of(context).size.width,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(text,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
      onTap: () async {
        action();
      },
    );
  }

}

