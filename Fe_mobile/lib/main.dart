import 'package:Fe_mobile/config/app_config.dart' as config;
import 'package:Fe_mobile/route_generator.dart';
import 'package:Fe_mobile/src/core/pages/usuario/bloc/info_perfil/info_usuario_bloc.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUtil();
  prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final prefs = new PreferenciasUtil();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => new InfoUsuarioBloc()),
        ],
        child: MaterialApp(
          title: 'Buya',
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData(
            fontFamily: 'Poppins',
            primaryColor: Color(0xFF252525),
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Color(0xFF2C2C2C),
            accentColor: config.Colors().mainDarkColor(1),
            hintColor: config.Colors().secondDarkColor(1),
            focusColor: config.Colors().accentDarkColor(1),
            textTheme: TextTheme(
              button: TextStyle(color: Color(0xFF252525)),
              headline1: TextStyle(
                  fontSize: 20.0, color: config.Colors().secondDarkColor(1)),
              headline2: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: config.Colors().secondDarkColor(1)),
              headline3: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: config.Colors().secondDarkColor(1)),
              headline4: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  color: config.Colors().mainDarkColor(1)),
              headline5: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w300,
                  color: config.Colors().secondDarkColor(1)),
              subtitle1: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: config.Colors().secondDarkColor(1)),
              subtitle2: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: config.Colors().mainDarkColor(1)),
              bodyText1: TextStyle(
                  fontSize: 12.0, color: config.Colors().secondDarkColor(1)),
              bodyText2: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: config.Colors().secondDarkColor(1)),
              caption: TextStyle(
                  fontSize: 12.0, color: config.Colors().secondDarkColor(0.7)),
            ),
          ),
          theme: ThemeData(
            fontFamily: 'Poppins',
            primaryColor: Colors.white,
            brightness: Brightness.light,
            accentColor: config.Colors().mainColor(1),
            focusColor: config.Colors().accentColor(1),
            hintColor: config.Colors().secondColor(1),
            textTheme: TextTheme(
              button: TextStyle(color: Colors.white),
              headline1: TextStyle(
                  fontSize: 20.0, color: config.Colors().secondColor(1)),
              headline2: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: config.Colors().secondColor(1)),
              headline3: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: config.Colors().secondColor(1)),
              headline4: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  color: config.Colors().mainColor(1)),
              headline5: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w300,
                  color: config.Colors().secondColor(1)),
              subtitle1: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: config.Colors().secondColor(1)),
              subtitle2: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: config.Colors().mainColor(1)),
              bodyText1: TextStyle(
                  fontSize: 12.0, color: config.Colors().secondColor(1)),
              bodyText2: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: config.Colors().secondColor(1)),
              caption: TextStyle(
                  fontSize: 12.0, color: config.Colors().secondColor(0.6)),
            ),
          ),
        ));
  }
}
