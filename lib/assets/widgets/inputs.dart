import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'styles.dart';

// ignore: must_be_immutable
class CustomInputField extends StatelessWidget {
  Icon fieldIcon;
  String hinText;
  var controller;
  bool obscure;
  TextInputType kb;
  List<TextInputFormatter> inputFormatter;
  String? Function(String?)? validator;
  int maxLines;
  double width;
  bool readOnly;

  CustomInputField(this.fieldIcon, this.hinText, this.controller, this.obscure,[this.kb=TextInputType.text,this.inputFormatter=const [] , 
  this.validator,this.maxLines=1,this.width=0,this.readOnly=false]);

  @override
  Widget build(BuildContext context) {
    if (this.width==0){
      this.width=MediaQuery.of(context).size.width*0.9;
    }
    return Container(
      width: width,
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
              ),
              width: width-50,
              //height: 60,
              child: Padding(

                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: kb,
                  maxLines: maxLines,
                  inputFormatters: inputFormatter,
                  obscureText: obscure,
                  controller: controller,
                  validator: validator,
                  readOnly: readOnly,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hinText,
                      fillColor: Colors.white,
                      filled: true),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
