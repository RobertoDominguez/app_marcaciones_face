import 'package:flutter/material.dart';
import '../../Session/ConfiguracionSession.dart';
import '../../assets/widgets/dialog.dart';
import '../../assets/widgets/styles.dart';

import '../../route_generator.dart';

class SideNav extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return __SideNavState();
  }

}

class __SideNavState extends State<SideNav>{


  List<Widget> listaDeCards=List.generate(0, (index) =>SizedBox(height: 1,));

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 31, 41, 55),
      child: Container(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Sucursal: ${ConfiguracionSession.configuracion.nombreSucursal}'
                  ,style: TextStyle(fontSize: 21,color: Style().textColorSeccondary(),fontWeight: FontWeight.w500),),
            ),
            Divider(
              color: Colors.white,
            ),

            cardRouteLeading(context, Icons.home, 'Menu', () { Navigator.pushReplacementNamed(context, menuRoute ); } ),

            cardRouteLeading(context,Icons.tag_faces_rounded, 'Gestionar Biometria', () { Navigator.pushNamed(context, facesRoute ); } ),

            cardRouteLeading(context,Icons.settings, 'Configuración', () { Navigator.pushReplacementNamed(context, configurarRoute ); } ),

            cardRouteLeading(context,Icons.book, 'Info', () { Navigator.pushReplacementNamed(context, configurarRoute ); } ),

          ],
        ),
      ),
    );
  }


    Widget cardRouteLeading(BuildContext context,IconData leadingIco, String text, VoidCallback action){
    return ListTile(
      title: Text(text,style: TextStyle(color: Style().textColorSeccondary()),),
      leading: Icon(leadingIco,color: Style().textColorSeccondary(),),
      // trailing: Icon(Icons.chevron_right, color: Style().textColorSeccondary(),),
      onTap: () async{
        action();
      },
    );
  }

}

PreferredSizeWidget headerAppBar(BuildContext context,Widget title){
  return AppBar(
    backgroundColor: Style().backgroundColor(),
    elevation: 0,
    titleSpacing: 0.0,
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          color: Style().primaryColor(),
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      },
    ),
    title: title
  );
}

PreferredSizeWidget headerAppBarBack(BuildContext context,Widget title){
  return AppBar(
      backgroundColor: Style().backgroundColor(),
      elevation: 0,
      titleSpacing: 0.0,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            color: Style().primaryColor(),
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              hideOpenDialog(context);
            },
            tooltip: 'Volver Atras',
          );
        },
      ),
      title: title
  );
}

Widget navigationHeader(BuildContext context,String title){
  return Container(
    color: Style().seccondaryColor(),
    width: MediaQuery.of(context).size.width,
    height: 50,
    child: Row(
      children: [
        SizedBox(width: 20,),
        Icon(Icons.home,color: Style().primaryColor(),),
        SizedBox(width: 20,),
        Icon(Icons.chevron_right,color: Style().uiColor(),),
        SizedBox(width: 20,),
        Text(title,style: TextStyle(color: Style().primaryColor(),fontSize: 20 ),)
      ],
    ),
  );
}
