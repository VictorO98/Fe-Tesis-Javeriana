// To parse this JSON data, do
//
//     final stepManejadorModel = stepManejadorModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

StepManejadorModel stepManejadorModelFromJson(String str) =>
    StepManejadorModel.fromJson(json.decode(str));

String stepManejadorModelToJson(StepManejadorModel data) =>
    json.encode(data.toJson());

class StepManejadorModel {
  StepManejadorModel({
    this.formulario,
    this.numeroStep,
    this.stepEstado,
  });

  String? formulario;
  int? numeroStep;
  StepState? stepEstado;

  factory StepManejadorModel.fromJson(Map<String, dynamic> json) =>
      StepManejadorModel(
        formulario: json["formulario"],
        numeroStep: json["numeroStep"],
        stepEstado: json["stepEstado"],
      );

  Map<String, dynamic> toJson() => {
        "formulario": formulario,
        "numeroStep": numeroStep,
        "stepEstado": stepEstado,
      };
}
