import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'styles.dart';

Widget customText(BuildContext context,Icon fieldIcon,String text){
  return Container(
    width: MediaQuery.of(context).size.width*0.9,
    child: Material(
      elevation: 5.0,
      borderRadius: BorderRadius.all(
          Radius.circular(20.0)),
      color: Style().textColorPrimary(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: fieldIcon,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)),
            ),
            width: MediaQuery.of(context).size.width*0.9-50,
            //height: 60,
            child: Padding(

              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                height: 40,
                child: Text(text,style: const TextStyle(fontSize: 20.0, color: Colors.black,),),
              )
            ),
          ),
        ],
      ),
    ),
  );
}