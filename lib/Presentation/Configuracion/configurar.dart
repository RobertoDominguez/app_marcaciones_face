import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Business/ConfiguracionBusiness.dart';
import '../../Data/DataResponse.dart';
import '../../Session/ConfiguracionSession.dart';
import '../../assets/widgets/buttons.dart';
import '../../assets/widgets/dialog.dart';
import '../../assets/widgets/headers.dart';
import '../../assets/widgets/inputs.dart';
import '../../assets/widgets/styles.dart';
import '../../env.dart';
import '../../route_generator.dart';

import '../Layouts/header.dart';


class Configurar extends StatefulWidget{
  const Configurar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return __ConfigurarState();
  }

}

class __ConfigurarState extends State<Configurar>{
  ConfiguracionBusiness configuracionBusiness=new ConfiguracionBusiness();

  bool isInitState=true;
  final controllerServidor = TextEditingController();
  final controllerCodigoSucursal = TextEditingController();
  final controllerCodigoPersona = TextEditingController();
  final controllerUsuario = TextEditingController();
  final controllerClave = TextEditingController();
  String servidor = "";
  String codigoSucursal = "";
  String codigoPersona = "";
  String usuario = "";
  String clave = "";

  @override
  void initState() {
    super.initState();
    configuracionEnSesion();
  }

  void configuracionEnSesion(){
    setState(() {
      if (ConfiguracionSession.configuracion.servidor!=""){
        controllerServidor.text=ConfiguracionSession.configuracion.servidor;
        servidor=ConfiguracionSession.configuracion.servidor;
      }

      if (ConfiguracionSession.configuracion.codigoSucursal!=""){
        controllerCodigoSucursal.text=ConfiguracionSession.configuracion.codigoSucursal;
        codigoSucursal=ConfiguracionSession.configuracion.codigoSucursal;
      }

      if (ConfiguracionSession.configuracion.codigoPersona!=""){
        controllerCodigoPersona.text=ConfiguracionSession.configuracion.codigoPersona;
        codigoPersona=ConfiguracionSession.configuracion.codigoPersona;
      }
    });

  }


  @override
  Widget build(BuildContext context) {

    if (isInitState){
      isInitState=false;
      controllerServidor.addListener(() {
        servidor = controllerServidor.text;
      });
      controllerCodigoSucursal.addListener(() {
        codigoSucursal=controllerCodigoSucursal.text;
      });
      controllerCodigoPersona.addListener(() {
        codigoPersona=controllerCodigoPersona.text;
      });
      controllerUsuario.addListener(() {
        usuario=controllerUsuario.text;
      });
      controllerClave.addListener(() {
        clave=controllerClave.text;
      });
    }
    return Scaffold(
      backgroundColor: Style().backgroundColor(),
      appBar: headerAppBar(context,titulo(context, "CONFIGURAR      ")),
      drawer: SideNav(),
      body: SafeArea(
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
    );
  }

  Widget todo(BuildContext context) {
    return
      SafeArea(
          child: Container(
            //padding: EdgeInsets.all(20.0),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Image.asset("${assetURL}config.png", alignment: Alignment.center, height: 50, width: 50,),
                SizedBox(height: 20.0),
                CustomInputField( Icon(Icons.home, color: Colors.white), "Servidor", controllerServidor, false),
                SizedBox(height: 20.0),
                CustomInputField( Icon(Icons.store, color: Colors.white), "Codigo Sucursal", controllerCodigoSucursal, false,TextInputType.number,
                  <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
                SizedBox(height: 20.0),
                CustomInputField( Icon(Icons.account_circle, color: Colors.white), "Codigo Persona", controllerCodigoPersona, false,TextInputType.number,
                  <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
                SizedBox(height: 20.0),
                CustomInputField( Icon(Icons.supervisor_account, color: Colors.white), "usuario Administrador", controllerUsuario, false),
                SizedBox(height: 20.0),
                CustomInputField( Icon(Icons.lock, color: Colors.white), "Clave", controllerClave, true),
                SizedBox(height: 40.0),
                buttonSeccondary(context, "GUARDAR", configurar),
              ],
            ),
          )
      );
  }

  Future<void> configurar() async{
    showLoadingIndicator(context,'Conectando con el servidor');

    DataResponse dataResponse=await configuracionBusiness.configurar(servidor,codigoSucursal,codigoPersona,usuario,clave);

    setState(() {
      hideOpenDialog(context);
      if (dataResponse.status){
        showAlertDialogContinue(context, "Configurado correctamente", dataResponse.message,(){ Navigator.pushReplacementNamed(context,menuRoute); });
      }else{
        showAlertDialog(context, "Error al configurar", dataResponse.message);
      }
    });
  }






}


