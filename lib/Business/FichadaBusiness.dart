import 'package:app_marcaciones_face/Entities/ImageData.dart';

import '../Data/DataResponse.dart';
import '../Data/FichadaData.dart';
import '../Entities/Fichada.dart';
import '../env.dart';
import '../Session/ConfiguracionSession.dart';

class FichadaBusiness {
  FichadaData fichadaData = FichadaData();

  Future<DataResponse> store(id_sucursal,codigo,fecha,hostname,ip,evento,manual,lat,long,List<ImageData> images) async {
    Fichada fichada = Fichada();
    fichada.id_sucursal = id_sucursal;
    fichada.codigo = codigo;
    fichada.fecha = fecha;
    fichada.hostname = hostname;
    fichada.ip = ip;
    fichada.evento = evento;
    fichada.images = images;
    fichada.manual = manual;

    return await fichadaData.store(apiKey,fichada,ConfiguracionSession.configuracion.servidor,lat,long);
  }
}
