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
    this.direccion,
    this.idPoblacion,
    this.idTipoCliente,
    this.idTipoClienteStr,
    this.idTipoDocumentoStr,
    this.idTipoDocumento,
    this.isAceptaTerminosYCondiciones,
  });

  String? nombres;
  String? apellidos;
  String? email;
  String? password;
  String? confirmPassword;
  String? numeroDocumento;
  String? codigoTelefonoPais;
  String? numeroTelefonico;
  String? direccion;
  String? idPoblacion;
  String? idTipoClienteStr;
  String? idTipoDocumentoStr;
  int? idTipoCliente;
  int? idTipoDocumento;
  bool? isAceptaTerminosYCondiciones;

  factory RegistroModel.fromJson(Map<String, dynamic> json) => RegistroModel(
        nombres: json["Nombres"],
        apellidos: json["Apellidos"],
        email: json["Email"],
        password: json["Password"],
        confirmPassword: json["ConfirmPassword"],
        numeroDocumento: json["NumeroDocumento"],
        codigoTelefonoPais: json["CodigoTelefonoPais"],
        numeroTelefonico: json["NumeroTelefonico"],
        direccion: json["Direccion"],
        idPoblacion: json["IdPoblacion"],
        idTipoCliente: json["IdTipoCliente"],
        idTipoDocumento: json["IdTipoDocumento"],
        isAceptaTerminosYCondiciones: json["IsAceptaTerminosYCondiciones"],
      );

  Map<String, dynamic> toJson() => {
        "Nombres": nombres,
        "Apellidos": apellidos,
        "Email": email,
        "Password": password,
        "ConfirmPassword": confirmPassword,
        "NumeroDocumento": numeroDocumento,
        "CodigoTelefonoPais": codigoTelefonoPais,
        "NumeroTelefonico": numeroTelefonico,
        "Direccion": direccion,
        "IdPoblacion": idPoblacion,
        "IdTipoCliente": idTipoCliente,
        "IdTipoDocumento": idTipoDocumento,
        "IsAceptaTerminosYCondiciones": isAceptaTerminosYCondiciones,
      };
}
