// To parse this JSON data, do
//
//     final respuestaPagoPseModel = respuestaPagoPseModelFromJson(jsonString);

import 'dart:convert';

RespuestaPagoPseModel respuestaPagoPseModelFromJson(String str) =>
    RespuestaPagoPseModel.fromJson(json.decode(str));

String respuestaPagoPseModelToJson(RespuestaPagoPseModel data) =>
    json.encode(data.toJson());

class RespuestaPagoPseModel {
  RespuestaPagoPseModel({
    this.refPayco,
    this.factura,
    this.descripcion,
    this.valor,
    this.iva,
    this.baseiva,
    this.moneda,
    this.respuesta,
    this.autorizacion,
    this.recibo,
    this.fecha,
    this.urlbanco,
    this.transactionId,
    this.ticketId,
    this.errores,
  });

  int? refPayco;
  String? factura;
  String? descripcion;
  String? valor;
  String? iva;
  String? baseiva;
  String? moneda;
  String? respuesta;
  String? autorizacion;
  String? recibo;
  String? fecha;
  String? urlbanco;
  String? transactionId;
  String? ticketId;
  dynamic errores;

  factory RespuestaPagoPseModel.fromJson(Map<String, dynamic> json) =>
      RespuestaPagoPseModel(
        refPayco: json["ref_payco"],
        factura: json["factura"],
        descripcion: json["descripcion"],
        valor: json["valor"],
        iva: json["iva"],
        baseiva: json["baseiva"],
        moneda: json["moneda"],
        respuesta: json["respuesta"],
        autorizacion: json["autorizacion"],
        recibo: json["recibo"],
        fecha: json["fecha"],
        urlbanco: json["urlbanco"],
        transactionId: json["transactionId"],
        ticketId: json["ticketId"],
        errores: json["errores"],
      );

  Map<String, dynamic> toJson() => {
        "ref_payco": refPayco,
        "factura": factura,
        "descripcion": descripcion,
        "valor": valor,
        "iva": iva,
        "baseiva": baseiva,
        "moneda": moneda,
        "respuesta": respuesta,
        "autorizacion": autorizacion,
        "recibo": recibo,
        "fecha": fecha,
        "urlbanco": urlbanco,
        "transactionId": transactionId,
        "ticketId": ticketId,
        "errores": errores,
      };
}
