import 'dart:typed_data';

import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../assets/widgets/styles.dart';

import 'package:file_picker/file_picker.dart';

Widget idDropdown(BuildContext context,String id,List<String> list,Map text,Function(String?) onChanged){
  return SizedBox(
    child: DropdownButton<String>(
      isExpanded: true,
      value: id,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontSize: 20),
      underline: Container(
        height: 2,
        color: Style().uiColor(),
      ),
      onChanged: (String? newValue) {
        onChanged(newValue);
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(text[value]),
          alignment: Alignment.center,
        );
      }).toList(),
    ),
    width: MediaQuery.of(context).size.width*0.9,
  );
}


Widget idDropdownCustom(BuildContext context,Icon fieldIcon,String id,List<String> list,Map text,Function(String?) onChanged){
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)),
            ),
            width: MediaQuery.of(context).size.width*0.9-50,
            //height: 60,
            child: Padding(

              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: id,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  underline: Container(
                    height: 2,
                    color: Colors.white,
                  ),
                  onChanged: (String? newValue) {
                    onChanged(newValue);
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(text[value]),
                      alignment: Alignment.center,
                    );
                  }).toList(),
                ),
                width: MediaQuery.of(context).size.width*0.9,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}





Widget idDropdownCustom2(BuildContext context,Icon fieldIcon,String id,List<String> list,Map text,Function(String?) onChanged,double width){
  return Container(
    width: width,
    child: Material(
      elevation: 5.0,
      borderRadius: const BorderRadius.all(
          Radius.circular(20.0)),
      color: Style().textColorPrimary(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0)),
        ),
        width: MediaQuery.of(context).size.width*0.9-50,
        //height: 60,
        child: Padding(

          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: DropdownButton<String>(
              isExpanded: true,
              value: id,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.black, fontSize: 20),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: (String? newValue) {
                onChanged(newValue);
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(text[value]),
                  alignment: Alignment.center,
                );
              }).toList(),
            ),
            width: width,
          ),
        ),
      ),
    ),
  );
}




Future<dynamic> uploadFile() async{
  FilePickerResult? result=await FilePicker.platform.pickFiles(
    //allowMultiple: false,
    //type: FileType.image,
    //allowedExtensions: ['jpg', 'png', 'jpeg', 'bmp']
  );

  if (result != null) {
    if (!kIsWeb){
      return result.files.single.path.toString();
    }
    if (kIsWeb){
      return result.files.first.bytes as Uint8List;
    }
  } else {
    // User canceled the picker
  }
}

String obtenerPathDeFoto(String str){
  String res="";
  bool end=false;
  for (int i=str.length-1; i>=0; i--){
    if (!end){
      res=str[i]+res;
      if (str[i]=='/' || str[i]=='\\'){
        end=true;
      }
    }
  }
  return res;
}

Future<dynamic> takePhoto()async{
  final ImagePicker _picker = ImagePicker();

  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

  if (photo!=null){

    return photo.path.toString();
  }else{

  }

}

Future<dynamic> uploadImage() async{
  FilePickerResult? result;
  if (!kIsWeb){
    result=await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
      //allowedExtensions: ['jpg', 'png', 'jpeg', 'bmp']
    );
  }
  if (kIsWeb){
    result = await FilePicker.platform.pickFiles(
      //allowMultiple: false,
      //type: FileType.image,
      //allowedExtensions: ['jpg', 'png', 'jpeg', 'bmp']
    );
  }

  if (result != null) {
    if (!kIsWeb){
      return result.files.single.path.toString();
    }
    if (kIsWeb){
      return result.files.first.bytes as Uint8List;
    }
  } else {
    // User canceled the picker
  }
}

Future<String> getTime(BuildContext context) async {

  TimeOfDay? _newTime=await showTimePicker(context: context,initialTime: TimeOfDay.now());
  if (_newTime!=null){
    String hour='${_newTime.hour}';
    String min='${_newTime.minute}';
    if (hour.length==1){
      hour='0'+hour;
    }
    if (min.length==1){
      min='0'+min;
    }
    return hour+':'+min;
  }
  return '';
}

Future<String> getDate(BuildContext context) async {
  DateTime? _newDate=await showDatePicker(context: context, initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime(3000));
  if (_newDate!=null){
    return '${_newDate.year}-${_newDate.month}-${_newDate.day}';
  }
  return '';
}
