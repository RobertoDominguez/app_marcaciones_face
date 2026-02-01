import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'styles.dart';



Widget buttonPrimary(BuildContext context,String text,VoidCallback action) {
  return Container(
    width: 260,
    height: 60,
    child: ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Style().primaryColor()),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Style().primaryColor())
              )
          )
      ),
      onPressed: () async {
        action();
      },
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Style().textColorSeccondary(),
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontStyle:FontStyle.italic
        ),
      ),
    ),
  );
}

Widget buttonSeccondary(BuildContext context,String text,VoidCallback action) {
  return SizedBox(
    width: 260,
    height: 60,
    child: ElevatedButton(
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Style().seccondaryColor()),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color:Style().seccondaryColor(),)
              )
          )
      ),
      onPressed: () async {
        action();
      },
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Style().textColorPrimary(),
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontStyle:FontStyle.italic
        ),
      ),
    ),
  );
}
