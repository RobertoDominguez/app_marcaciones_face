import 'package:app_marcaciones_face/Business/BiometricoBusiness.dart';
import 'package:app_marcaciones_face/Data/DataResponse.dart';
import 'package:app_marcaciones_face/Presentation/Layouts/header.dart';
import 'package:app_marcaciones_face/assets/widgets/dialog.dart';
import 'package:app_marcaciones_face/assets/widgets/styles.dart';
import 'package:app_marcaciones_face/route_generator.dart';
import 'package:flutter/material.dart';
import '../../assets/widgets/headers.dart';
import '../../assets/widgets/searchs.dart';

class FacesIndex extends StatefulWidget{
  const FacesIndex({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return __FacesIndexState();
  }

}

class __FacesIndexState extends State<FacesIndex>{

  BiometricoBusiness biometricoBusiness = BiometricoBusiness();
  List<Widget> listaDeCards = [];

  List<String> listaDeCodigos = [];
  List<String> listaDeCodigosSearch = [];

  @override
  void initState() {
    super.initState();
    loadFaces(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style().backgroundColor(),
      resizeToAvoidBottomInset: false,
      appBar: headerAppBarBack(context,titulo(context, "BIOMETRICO      ")),
      drawer: SideNav(),
      body: SafeArea(
          child: todo(context)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, registrarFaceRoute);
        },
        foregroundColor: Style().textColorPrimary(),
        backgroundColor: Style().seccondaryColor(),
        shape: CircleBorder(),
        child: const Icon(Icons.add_reaction),
      ),
    );
  }


  Widget todo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 60,
            child: searchBar(context,loadCodigosSearch),
          ),
          Expanded(child: SizedBox(width: (MediaQuery.of(context).size.height<600)? MediaQuery.of(context).size.height : 600,child: listOfVisita(),
          ),
          ),
        ],
      ),
    );

  }


  void loadFaces(BuildContext context) async{

    await Future.delayed(Duration(milliseconds: 10));
    showLoadingIndicator(context,'');
    DataResponse dataResponse=await biometricoBusiness.faces();
    listaDeCodigos = dataResponse.data;
    loadCodigosSearch(context, '');
    hideOpenDialog(context);
  }

  void loadCodigosSearch(BuildContext context,String search)async{

    if (search!=''){
      listaDeCodigosSearch = [];
      listaDeCodigos.forEach((element) {
        if (element.toLowerCase().contains(search.toLowerCase()) ){
          listaDeCodigosSearch.add(element);
        }
      });
    }else{
      listaDeCodigosSearch = listaDeCodigos;
    }

    setState(() {
      listaDeCards=List.generate(0, (index) =>SizedBox(height: 1,));
      listaDeCodigosSearch.forEach((item) {
        var c = cardFace(context,item);
        listaDeCards.add(c);
      });
    });
  }

  Widget listOfVisita() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: listaDeCards.length,
        padding: new EdgeInsets.only(top: 5.0),
        itemBuilder: (context, index) {
          return listaDeCards[index];
        });
  }

  Widget cardFace(BuildContext context,String codigo){
    return GestureDetector(
      onTap: (){
        
      },
      child: Card(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.credit_card,color: Style().uiColor(),size: 25,),
                          SizedBox(width: 20,),
                          Text(codigo,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 20),)
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Icon(Icons.account_circle,color: Style().uiColor() ,size: 25,),
                          SizedBox(width: 20,),
                          SizedBox(
                            height: 20,
                            width: MediaQuery.of(context).size.width*0.5,
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                                fit: BoxFit.contain,
                                child: Text('Persona Registrada',style: TextStyle(color: Colors.black54),)
                            ),
                          ),
                          //Text(visita.nombre,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15),)
                        ],
                      ),
                    ],
                  ),
                )
              ), 
              IconButton(onPressed: (){
                  deleteCode(codigo);
                },
                icon: Icon(Icons.delete,size: 40, color: Style().dangerColor(),)
              )
              
            ],
          )
        ),
      ),
    );
  }




  /// ==========================
  /// ELIMINAR PERSONA
  /// ==========================
  Future<void> deleteCode(String code) async {

    showAlertDialogOptions(context,'Eliminar Biometria','¿Desea eliminar el registro: $code ?',()async{
      try {
          showLoadingIndicator(context, 'Eliminando registro biometrico...');

          DataResponse dataResponse = await biometricoBusiness.delete(code);

          hideOpenDialog(context);

          if (dataResponse.status) {
            showAlertDialogContinue(
              context,
              "Eliminado con exito!",
              dataResponse.message,
              () {
                Navigator.pushReplacementNamed(context, facesRoute);
              },
            );
          } else {
            showAlertDialog(
              context,
              "Error al eliminar Registro biometrico",
              dataResponse.message,
            );
          }
        } catch (e) {
          hideOpenDialog(context);
          showAlertDialogMessage(context, 'Error', e.toString());
        }
    });
    
  }


}