import 'dart:convert';

import 'package:Fe_mobile/src/core/models/departamentos_model.dart';
import 'package:Fe_mobile/src/core/models/municipios_model.dart';
import 'package:Fe_mobile/src/core/models/tipo_documento_model.dart';
import 'package:Fe_mobile/src/core/models/rol_model.dart';
import 'package:Fe_mobile/src/core/util/servicio_util.dart';

class GeneralProvider {
  Future<List<TipoDocumentoCorModel>> getTipoDocumentos() async {
    String data = await ServicioUtil.get("core/COGeneral/GetTipoDocumento");
    if (data == null) return [];
    final List<dynamic> decodedData = json.decode(data);
    final List<TipoDocumentoCorModel> listado =
        List<TipoDocumentoCorModel>.from(
            decodedData.map((model) => TipoDocumentoCorModel.fromJson(model)));

    return listado;
  }

  Future<List<DepartamentoModel>> getDepartamentos() async {
    String data = await ServicioUtil.get("core/COGeneral/GetEstadoPoblacion");
    if (data == null) return [];
    final List<dynamic> decodedData = json.decode(data);
    final List<DepartamentoModel> listado = List<DepartamentoModel>.from(
        decodedData.map((model) => DepartamentoModel.fromJson(model)));

    return listado;
  }

  Future<List<MunicipiosModel>> getMunicipioPorIdEstado(int idEstado) async {
    String data = await ServicioUtil.get(
        "core/COGeneral/GetPoblacionPorIdEstado",
        params: {"idEstado": idEstado.toString()});
    if (data == null) return [];
    final List<dynamic> decodedData = json.decode(data);
    final List<MunicipiosModel> listado = List<MunicipiosModel>.from(
        decodedData.map((model) => MunicipiosModel.fromJson(model)));

    return listado;
  }

  Future<List<RolModel>> getRoles() async {
    String data = await ServicioUtil.get("api/Authenticate/GetRoles");
    if (data == null) return [];
    final List<dynamic> decodedData = json.decode(data);
    final List<RolModel> listado = List<RolModel>.from(
        decodedData.map((model) => RolModel.fromJson(model)));

    return listado;
  }
}
