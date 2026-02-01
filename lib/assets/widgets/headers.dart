import 'package:flutter/material.dart';
import 'styles.dart';

Widget titulo(BuildContext context,String content){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(content,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Style().textColorPrimary()),),
    ],
  );
}

Widget tituloSearch(BuildContext context,String content,VoidCallback action){
  return Stack(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: 50,
            child: Text(content,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Style().textColorPrimary()),),
          )

        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(onPressed: action, icon: const Icon(Icons.search,size:20,color: Colors.black,))
        ],
      ),
    ],
  );
}