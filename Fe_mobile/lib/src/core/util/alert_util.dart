import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';

class AlertUtil {
  static success(BuildContext context, String message,
      {Function() respuesta, String title = "Exitoso!!!"}) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: message,
        cancelBtnText: "Cancelar",
        title: title,
        onConfirmBtnTap: respuesta);
  }

  static error(BuildContext context, String message, {Function() respuesta}) {
    CoolAlert.show(context: context, type: CoolAlertType.error, text: message);
  }

  static confirm(BuildContext context, String message, Function() respuesta,
      {String confirmBtnText, String title = "CONFIRMAR"}) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        text: message,
        confirmBtnText: confirmBtnText,
        cancelBtnText: "Cancelar",
        title: title,
        onConfirmBtnTap: respuesta);
  }

  static info(BuildContext context, String message, {Function() respuesta}) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.info,
        text: message,
        onConfirmBtnTap: respuesta);
  }

  static loading(BuildContext context, String message) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.loading,
      text: message,
    );
  }
}
