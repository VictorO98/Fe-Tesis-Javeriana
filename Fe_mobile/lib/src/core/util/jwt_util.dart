import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:Fe_mobile/src/core/providers/usuario_provider.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';

class JWTUtil {
  static Map<String, dynamic> decodificarToken(String token) {
    var a = JwtDecoder.decode(token);
    return a;
  }

  static Future<bool> isTokenExpirado() async {
    PreferenciasUtil prefs = new PreferenciasUtil();
    if (prefs == null) return true;
    String token = await prefs.getPrefStr("token");
    print((token == null || token == "") || JwtDecoder.isExpired(token));
    if ((token == null || token == "") || JwtDecoder.isExpired(token)) {
      return true;
    }

    return false;
  }

  static void refrescarToken() async {
    bool isTokenExpired = await isTokenExpirado();
    if (!isTokenExpired) {
      PreferenciasUtil prefs = new PreferenciasUtil();
      String token = await prefs.getPrefStr("token");
      Duration tokenTime = JwtDecoder.getTokenTime(token);
      if (tokenTime.inDays > 55 && tokenTime.inDays < 60) {
        UsuarioProvider _usuarioProvider = new UsuarioProvider();
        var data = await _usuarioProvider.refreshToken(token);
        if (data.codigo == 10) {
          PreferenciasUtil prefs = new PreferenciasUtil();
          prefs.setPrefStr("token", data.token);
        } else {
          // AlertUtil.info(
          //     context, "Por favor cierra sesión y vuelve a iniciar. ");
        }
      }
    }
  }

  static Future<void> addPreferenciasUsuario(
      Map<String, dynamic> claims) async {
    PreferenciasUtil prefs = new PreferenciasUtil();
    await prefs.setPrefStr("id", claims["id"]);
    await prefs.setPrefStr("nombres", claims["nombres"]);
    await prefs.setPrefStr("apellidos", claims["apellidos"]);
    await prefs.setPrefStr("telefono", claims["telefono"]);
    await prefs.setPrefStr("email", claims["email"]);
    await prefs.setPrefStr("documento", claims["documento"]);
    await prefs.setPrefStr("tipoDocumento", claims["tipoDocumento"]);
    await prefs.setPrefStr(
        "nombreCompleto", "${claims["nombres"]} ${claims["apellidos"]}");
    await prefs.setPrefStr("roles", claims["roles"]);
  }

  static Future<void> removerTokenYValoresUsuario() async {
    PreferenciasUtil prefs = new PreferenciasUtil();
    await prefs.removePrefStr("id");
    await prefs.removePrefStr("nombres");
    await prefs.removePrefStr("apellidos");
    await prefs.removePrefStr(
      "telefono",
    );
    await prefs.removePrefStr("email");
    await prefs.removePrefStr("nombreCompleto");
    await prefs.removePrefStr("menu");
    await prefs.removePrefStr("roles");
    await prefs.removePrefStr("token");
    await prefs.removePrefStr("documento");
    await prefs.removePrefStr("tipoDocumento");
  }
}
