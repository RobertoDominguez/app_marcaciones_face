// Widget que protege la view de faces y new_face
import 'package:flutter/material.dart';
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


class AuthBiometrico extends StatefulWidget{
  const AuthBiometrico({super.key});

  @override
  State<StatefulWidget> createState() {
    return __AuthBiometricoState();
  }

}

class __AuthBiometricoState extends State<AuthBiometrico>{
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
      controllerUsuario.addListener(() {
        usuario=controllerUsuario.text;
      });
      controllerClave.addListener(() {
        clave=controllerClave.text;
      });
    }
    return Scaffold(
      backgroundColor: Style().backgroundColor(),
      appBar: headerAppBarBack(context,titulo(context, "AUTENTIFICACIÓN      ")),
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
                Image.asset("${assetURL}login.png", alignment: Alignment.center, height: 50, width: 50,),
                SizedBox(height: 20.0),
                CustomInputField( Icon(Icons.supervisor_account, color: Colors.white), "usuario Administrador", controllerUsuario, false),
                SizedBox(height: 20.0),
                CustomInputField( Icon(Icons.lock, color: Colors.white), "Clave", controllerClave, true),
                SizedBox(height: 40.0),
                buttonSeccondary(context, "Iniciar Sesion", authBiometrico),
              ],
            ),
          )
      );
  }

  Future<void> authBiometrico() async{
    showLoadingIndicator(context,'Conectando con el servidor');

    DataResponse dataResponse=await configuracionBusiness.configurarBiometrico(servidor,codigoSucursal,codigoPersona,usuario,clave);

    setState(() {
      hideOpenDialog(context);
      if (dataResponse.status){
       Navigator.pushReplacementNamed(context,facesRoute); 
      }else{
        showAlertDialog(context, "Error al autentificar usuario.", dataResponse.message);
      }
    });
  }






}


