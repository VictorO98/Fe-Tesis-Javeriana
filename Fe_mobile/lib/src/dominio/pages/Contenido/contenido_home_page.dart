import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/core/models/info_usuario_model.dart';
import 'package:Fe_mobile/src/core/pages/usuario/bloc/info_perfil/info_usuario_bloc.dart';
import 'package:Fe_mobile/src/core/util/conf_api.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/core/util/publicaciones_util.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/dominio/providers/contenido_provider.dart';
import 'package:Fe_mobile/src/models/brand.dart';
import 'package:Fe_mobile/src/models/category.dart';
import 'package:Fe_mobile/src/models/product.dart';
import 'package:Fe_mobile/src/widgets/BrandsIconsCarouselWidget.dart';
import 'package:Fe_mobile/src/widgets/CategoriesIconsCarouselWidget.dart';
import 'package:Fe_mobile/src/widgets/CategorizedProductsWidget.dart';
import 'package:Fe_mobile/src/widgets/FlashSalesCarouselWidget.dart';
import 'package:Fe_mobile/src/widgets/FlashSalesWidget.dart';
import 'package:Fe_mobile/src/widgets/HomeSliderWidget.dart';
import 'package:Fe_mobile/src/widgets/SearchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ContenidoHomePage extends StatefulWidget {
  @override
  _ContenidoHomePageState createState() => _ContenidoHomePageState();
}

class _ContenidoHomePageState extends State<ContenidoHomePage>
    with SingleTickerProviderStateMixin {
  CategoriesList _categoriesList = new CategoriesList();
  BrandsList _brandsList = new BrandsList();

  Animation? animationOpacity;
  late AnimationController animationController;

  final _prefs = new PreferenciasUtil();

  ContenidoProvider _contenidoProvider = new ContenidoProvider();

  InfoUsuarioBloc? _infoUsuarioBloc;

  List<ProductoServicioModel>? _publicacioneDescuento;
  List<ProductoServicioModel>? _productos;
  List<ProductoServicioModel>? _servicios;

  bool _cargandoUsuario = false;
  bool _cargarProductosDescuento = false;
  bool _cargarProductos = false;
  bool _cargarServicios = false;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    animationController.forward();

    // _productsOfCategoryList = _categoriesList.list!.firstWhere((category) {
    //   return category.selected;
    // }).products;

    // _productsOfBrandList = _brandsList.list!.firstWhere((brand) {
    //   return brand.selected!;
    // }).products;
    //

    super.initState();
    _infoUsuarioBloc = BlocProvider.of<InfoUsuarioBloc>(context);
    _initialConfiguration();
    _getProductosEnDescuento();
    // _getProductos();
    // _getServicios();
  }

  _initialConfiguration() async {
    // setState(() {
    //   _cargandoUsuario = true;
    // });

    if (_infoUsuarioBloc!.state.infoUsuarioModel != null) {
      _infoUsuarioBloc!.add(OnSetearInfoUsuario(new InfoUsuarioModel(
          id: await _prefs.getPrefStr("id"),
          documento: await _prefs.getPrefStr("documento"),
          tipoDocumento: await _prefs.getPrefStr("tipoDocumento"),
          email: await _prefs.getPrefStr("email"),
          nombres: await _prefs.getPrefStr("nombres"),
          apellidos: await _prefs.getPrefStr("apellidos"),
          nombreCompleto: await _prefs.getPrefStr("nombreCompleto"),
          numeroTelefono: await _prefs.getPrefStr("telefono"),
          rol: await _prefs.getPrefStr("roles"),
          direccion: await _prefs.getPrefStr("direccion"),
          estado: await _prefs.getPrefStr("estado"),
          poblacion: await _prefs.getPrefStr("poblacion"))));

      // setState(() {
      //   _cargandoUsuario = false;
      // });
    }
  }

  _getProductosEnDescuento() async {
    _publicacioneDescuento = await _contenidoProvider
        .getProductosDescuento(_infoUsuarioBloc!.state.infoUsuarioModel!.id!);
    if (_publicacioneDescuento != null) {
      for (var i = 0; i < _publicacioneDescuento!.length; i++) {
        _publicacioneDescuento![i].urlimagenproductoservicio =
            "${ConfServer.SERVER}dominio/COContenido/GetImagenProdcuto?idPublicacion=${_publicacioneDescuento![i].id}";
      }
      if (mounted)
        setState(() {
          if (_publicacioneDescuento == null ||
              _publicacioneDescuento!.length == 0) {
            _publicacioneDescuento = null;
          }
          _cargarProductosDescuento = true;
        });
      // setState(() {
      //   _cargarProductosDescuento = true;
      // });
    }
  }

  _getProductos() async {
    _productos = await _contenidoProvider.filtroTipoPublicacion(
        context, PublicacionUtil.PRODUCTO);
    if (_productos != null) {
      for (var i = 0; i < _productos!.length; i++) {
        _productos![i].urlimagenproductoservicio =
            "${ConfServer.SERVER}dominio/COContenido/GetImagenProdcuto?idPublicacion=${_productos![i].id}";
      }
      setState(() {
        _cargarProductos = true;
      });
    }
  }

  _getServicios() async {
    _servicios = await _contenidoProvider.filtroTipoPublicacion(
        context, PublicacionUtil.SERVICIO);
    if (_servicios != null) {
      for (var i = 0; i < _servicios!.length; i++) {
        _servicios![i].urlimagenproductoservicio =
            "${ConfServer.SERVER}dominio/COContenido/GetImagenProdcuto?idPublicacion=${_servicios![i].id}";
      }
      setState(() {
        _cargarServicios = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBarWidget(),
        ),
        HomeSliderWidget(),
        _publicacioneDescuento != null
            ? _publicacioneDescuento!.length != 0
                ? FlashSalesHeaderWidget()
                : SizedBox()
            : SizedBox(),

        _publicacioneDescuento != null
            ? _cargarProductosDescuento
                ? FlashSalesCarouselWidget(
                    heroTag: 'home_flash_sales',
                    productsList: _publicacioneDescuento)
                : Center(child: CircularProgressIndicator())
            : SizedBox(),
        // Heading (Recommended for you)
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        //   child: ListTile(
        //     dense: true,
        //     contentPadding: EdgeInsets.symmetric(vertical: 0),
        //     leading: Icon(
        //       Icons.star_border_outlined,
        //       color: Theme.of(context).hintColor,
        //     ),
        //     title: Text(
        //       'Productos',
        //       style: Theme.of(context).textTheme.headline4,
        //     ),
        //   ),
        // ),
        // StickyHeader(
        //   header: CategoriesIconsCarouselWidget(
        //       heroTag: 'home_categories_1',
        //       publicacion: _productos,
        //       onChanged: (id) {
        //         // setState(() {
        //         //   animationController.reverse().then((f) {
        //         //     _productsOfCategoryList =
        //         //         _categoriesList.list!.firstWhere((category) {
        //         //       return category.id == id;
        //         //     }).products;
        //         //     animationController.forward();
        //         //   });
        //         // });
        //       }),
        //   content: CategorizedProductsWidget(
        //       animationOpacity: animationOpacity, productsList: _productos),
        // ),
        // Heading (Brands)
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        //   child: ListTile(
        //     dense: true,
        //     contentPadding: EdgeInsets.symmetric(vertical: 0),
        //     leading: Icon(
        //       UiIcons.flag,
        //       color: Theme.of(context).hintColor,
        //     ),
        //     title: Text(
        //       'Servicios',
        //       style: Theme.of(context).textTheme.headline4,
        //     ),
        //   ),
        // ),
        // // StickyHeader(
        // //   header: BrandsIconsCarouselWidget(
        // //       heroTag: 'home_brand_1',
        // //       brandsList: _brandsList,
        // //       onChanged: (id) {
        // //         setState(() {
        // //           animationController.reverse().then((f) {
        // //             _productsOfBrandList =
        // //                 _brandsList.list!.firstWhere((brand) {
        // //               return brand.id == id;
        // //             }).products;
        // //             animationController.forward();
        // //           });
        // //         });
        // //       }),
        // //   content: CategorizedProductsWidget(
        // //       animationOpacity: animationOpacity,
        // //       productsList: _productsOfBrandList),
        // // ),
      ],
    );
//      ],
//    );
  }
}
