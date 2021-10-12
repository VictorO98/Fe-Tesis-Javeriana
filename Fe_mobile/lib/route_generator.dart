import 'package:Fe_mobile/src/core/pages/usuario/foto_usuario_page.dart';
import 'package:Fe_mobile/src/dominio/pages/Contenido/crear_servicio_producto_page.dart';
import 'package:Fe_mobile/src/dominio/pages/contenido/busqueda_productos_page.dart';
import 'package:Fe_mobile/src/dominio/pages/contenido/editar_publicacion_page.dart';
import 'package:Fe_mobile/src/dominio/pages/contenido/publicaciones_usuario_page.dart';
import 'package:Fe_mobile/src/dominio/pages/trueques/lista_solicitud_trueques_page.dart';
import 'package:Fe_mobile/src/dominio/pages/trueques/listado_trueques_usuario_page.dart';
import 'package:Fe_mobile/src/dominio/pages/trueques/ofertar_trueque_page.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:Fe_mobile/src/screens/brand.dart';
import 'package:Fe_mobile/src/screens/brands.dart';
import 'package:Fe_mobile/src/dominio/pages/carrito/carrito_compras_page.dart';
import 'package:Fe_mobile/src/screens/categories.dart';
import 'package:Fe_mobile/src/screens/category.dart';
import 'package:Fe_mobile/src/screens/checkout.dart';
import 'package:Fe_mobile/src/screens/checkout_done.dart';
import 'package:Fe_mobile/src/screens/help.dart';
import 'package:Fe_mobile/src/screens/languages.dart';
import 'package:Fe_mobile/src/core/pages/induccion_page.dart';
import 'package:Fe_mobile/src/screens/orders.dart';
import 'package:Fe_mobile/src/dominio/pages/contenido/producto_detalle_page.dart';
import 'package:Fe_mobile/src/core/pages/usuario/login_page.dart';
import 'package:Fe_mobile/src/core/pages/usuario/registro_page.dart';
import 'package:Fe_mobile/src/screens/tabs.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => InduccionPage());
      case '/Registro':
        return MaterialPageRoute(builder: (_) => RegistroPage());
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/Categories':
        return MaterialPageRoute(builder: (_) => CategoriesWidget());
      case '/Orders':
        return MaterialPageRoute(builder: (_) => OrdersWidget());
      case '/Create':
        return MaterialPageRoute(builder: (_) => CrearServicioProductoPage());
      case '/Brands':
        return MaterialPageRoute(builder: (_) => BrandsWidget());
      case '/FotoPerfil':
        return MaterialPageRoute(builder: (_) => FotoUsuarioPage());
//      case '/MobileVerification':
//        return MaterialPageRoute(builder: (_) => MobileVerification());
//      case '/MobileVerification2':
//        return MaterialPageRoute(builder: (_) => MobileVerification2());
      case '/SolicitudTrueques':
        return MaterialPageRoute(
            builder: (_) => ListadoSolicitudTruequesWidget(
                routeArgument: args as RouteArgument?));
      case '/TruquesUsuario':
        return MaterialPageRoute(
            builder: (_) => ListadoTruequesUsuarioWidget(
                routeArgument: args as RouteArgument?));
      case '/EditarPublicacion':
        return MaterialPageRoute(
            builder: (_) =>
                EditarPublicacionPage(routeArgument: args as RouteArgument?));
      case '/Trueque':
        return MaterialPageRoute(
            builder: (_) =>
                OfertarTruequePage(routeArgument: args as RouteArgument?));
      case '/MisPub':
        return MaterialPageRoute(
            builder: (_) => PublicacionesUsuarioPage(
                routeArgument: args as RouteArgument?));
      case '/Tabs':
        return MaterialPageRoute(
            builder: (_) => TabsWidget(
                  currentTab: args as int?,
                ));
      case '/Category':
        return MaterialPageRoute(
            builder: (_) =>
                CategoryWidget(routeArgument: args as RouteArgument?));
      case '/Brand':
        return MaterialPageRoute(
            builder: (_) => BrandWidget(routeArgument: args as RouteArgument?));
      case '/Product':
        return MaterialPageRoute(
            builder: (_) =>
                ProductoDetallePage(routeArgument: args as RouteArgument?));
      case '/Busqueda':
        return MaterialPageRoute(
            builder: (_) =>
                BusquedaProductosPage(routeArgument: args as RouteArgument?));
//      case '/Food':
//        return MaterialPageRoute(
//            builder: (_) => FoodWidget(
//              routeArgument: args as RouteArgument,
//            ));
      case '/Checkout':
        return MaterialPageRoute(builder: (_) => CheckoutWidget());
      case '/Cart':
        return MaterialPageRoute(builder: (_) => CartWidget());
      case '/CheckoutDone':
        return MaterialPageRoute(builder: (_) => CheckoutDoneWidget());
      case '/Help':
        return MaterialPageRoute(builder: (_) => HelpWidget());
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget());
//      case '/second':
//      // Validation of correct data type
//        if (args is String) {
//          return MaterialPageRoute(
//            builder: (_) => SecondPage(
//              data: args,
//            ),
//          );
//        }
//        // If args is not of the correct type, return an error page.
//        // You can also throw an exception while in development.
//        return _errorRoute();
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
