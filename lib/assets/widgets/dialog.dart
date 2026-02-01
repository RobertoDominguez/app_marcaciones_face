import 'package:flutter/material.dart';


Future<void> showAlertDialog(BuildContext context,String header,String text) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(header, style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: Colors.black87,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text, style: TextStyle(color: Colors.white, fontSize: 16))
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showAlertDialogContinue(BuildContext context,String header,String text,VoidCallback action) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(header, style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: Colors.black87,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text, style: TextStyle(color: Colors.white, fontSize: 16))
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
              action();
            },
          ),
        ],
      );
    },
  );
}

void showLoadingIndicator(BuildContext context, String text) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),
            backgroundColor: Colors.black87,
            content: LoadingIndicator(
                text: text
            ),
          )
      );
    },
  );
}


void hideOpenDialog(BuildContext context) {
  Navigator.of(context).pop();
}



Future<void> showAlertDialogOptions(BuildContext context,String title,String question,VoidCallback action) async{

  Widget cancelButton = TextButton(
    child: Text("Cancelar"),
    onPressed:  () {
      hideOpenDialog(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text("Continuar"),
    onPressed:  () async{
      hideOpenDialog(context);
      action();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16),),
    backgroundColor: Colors.black87,
    content: Text(question, style: TextStyle(color: Colors.white, fontSize: 16),),
    buttonPadding: EdgeInsets.all(10),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}



class LoadingIndicator extends StatelessWidget{
  LoadingIndicator({this.text = ''});

  final String text;

  @override
  Widget build(BuildContext context) {
    var displayedText = text;

    return Container(
        padding: EdgeInsets.all(16),
        color: Colors.black87,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getLoadingIndicator(),
              _getHeading(context),
              _getText(displayedText)
            ]
        )
    );
  }

  Padding _getLoadingIndicator() {
    return Padding(
        child: Container(
            child: CircularProgressIndicator(
                strokeWidth: 3
            ),
            width: 32,
            height: 32
        ),
        padding: EdgeInsets.only(bottom: 16)
    );
  }

  Widget _getHeading(context) {
    return
      Padding(
          child: Text(
            'Por favor espera …',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16
            ),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.only(bottom: 4)
      );
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: TextStyle(
          color: Colors.white,
          fontSize: 14
      ),
      textAlign: TextAlign.center,
    );
  }
}

Future<void> showAlertDialogMessage(BuildContext context,String title,String content) async{

  AlertDialog alert = AlertDialog(
    title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16),),
    backgroundColor: Colors.black87,
    content: Text(content, style: TextStyle(color: Colors.white, fontSize: 16),),
    buttonPadding: EdgeInsets.all(10),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))
    ),

  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}