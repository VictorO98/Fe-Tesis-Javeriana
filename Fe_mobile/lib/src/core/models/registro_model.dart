// To parse this JSON data, do
//
//     final registroModel = registroModelFromJson(jsonString);

import 'dart:convert';

RegistroModel registroModelFromJson(String str) =>
    RegistroModel.fromJson(json.decode(str));

String registroModelToJson(RegistroModel data) => json.encode(data.toJson());

class RegistroModel {
  RegistroModel({
    this.nombres,
    this.apellidos,
    this.email,
    this.password,
    this.confirmPassword,
    this.numeroDocumento,
    this.codigoTelefonoPais,
    this.numeroTelefonico,
    this.idTipoCliente,
    this.idTipoDocumento,
    this.isAceptaTerminosYCondiciones,
  });

  String nombres;
  String apellidos;
  String email;
  String password;
  String confirmPassword;
  String numeroDocumento;
  String codigoTelefonoPais;
  String numeroTelefonico;
  int idTipoCliente;
  String idTipoClienteStr;
  int idTipoDocumento;
  String idTipoDocumentoStr;
  bool isAceptaTerminosYCondiciones;

  factory RegistroModel.fromJson(Map<String, dynamic> json) => RegistroModel(
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        email: json["email"],
        password: json["password"],
        confirmPassword: json["confirmPassword"],
        numeroDocumento: json["numeroDocumento"],
        codigoTelefonoPais: json["codigoTelefonoPais"],
        numeroTelefonico: json["numeroTelefonico"],
        idTipoCliente: json["idTipoCliente"],
        idTipoDocumento: json["idTipoDocumento"],
        isAceptaTerminosYCondiciones: json["isAceptaTerminosYCondiciones"],
      );

  Map<String, dynamic> toJson() => {
        "nombres": nombres,
        "apellidos": apellidos,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "numeroDocumento": numeroDocumento,
        "codigoTelefonoPais": codigoTelefonoPais,
        "numeroTelefonico": numeroTelefonico,
        "idTipoCliente": idTipoCliente,
        "idTipoDocumento": idTipoDocumento,
        "isAceptaTerminosYCondiciones": isAceptaTerminosYCondiciones,
      };
}
