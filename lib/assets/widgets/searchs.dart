import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'styles.dart';

Widget searchBar(BuildContext context,Function(BuildContext,String) action){
  return Column(
    children: [
      CupertinoSearchTextField(
        placeholder: 'Buscar persona',
        backgroundColor: Style().backgroundColor(),
        onTap: (){
          
        },
        onSubmitted: (String text){

        } ,
        onChanged: (String text){
          action(context,text);
        },
      ),
      Divider(
        color: Colors.grey.shade400,
      ),
    ],
  );
}



