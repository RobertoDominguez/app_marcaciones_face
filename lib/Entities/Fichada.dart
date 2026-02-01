import 'package:app_marcaciones_face/Entities/ImageData.dart';

class Fichada {
  String id = '';
  String id_sucursal = '';
  String codigo = '';
  String fecha = '';
  String evento = '';
  String hostname = '';
  String ip = '';
  String manual = '';
  String usado = '';
  List<ImageData> images = []; //foto, foto2, foto3

  //Fichada({constructor});

  Map toMapStore() {
    return {
      'codigo': this.codigo,
      'fecha': this.fecha,
      'hostname': this.hostname,
      'ip': this.ip,
      'id_sucursal': this.id_sucursal,
      'evento': this.evento,
      'manual':this.manual,
      
    };
  }
}