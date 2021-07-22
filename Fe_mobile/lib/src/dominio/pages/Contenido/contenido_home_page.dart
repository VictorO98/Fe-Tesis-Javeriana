import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/core/util/conf_api.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
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

  List<ProductoServicioModel>? _publicacioneDescuento;
  List<ProductoServicioModel>? _productos;
  List<ProductoServicioModel>? _servicios;

  String? idUsuario;

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
    _initialConfiguration();
    _getProductosEnDescuento();
    // _getProductos();
    // _getServicios();
    super.initState();
  }

  // _getImagenEvidencia(ProductoServicioModel producto) {
  //   return Image.network(
  //     "${ConfServer.SERVER}dominio/COContenido/GetImagenProdcuto?idPublicacion=${producto!.id}&idUsuario=${idUsuario}",
  //   );
  // }

  _initialConfiguration() async {
    idUsuario = await _prefs.getPrefStr("id");
  }

  _getProductosEnDescuento() async {
    _publicacioneDescuento = await _contenidoProvider.getProductosDescuento();
    for (var i = 0; i < _publicacioneDescuento!.length; i++) {
      _publicacioneDescuento![i].urlimagenproductoservicio =
          "${ConfServer.SERVER}dominio/COContenido/GetImagenProdcuto?idPublicacion=${_publicacioneDescuento![i].id}&idUsuario=$idUsuario";
    }
    setState(() {
      _cargarProductosDescuento = true;
    });
  }

  _getProductos() async {
    _productos = await _contenidoProvider.filtroTipoPublicacion(context, 1);
    setState(() {
      _cargarProductos = true;
    });
  }

  _getServicios() async {
    _servicios = await _contenidoProvider.filtroTipoPublicacion(context, 2);
    setState(() {
      _cargarServicios = true;
    });
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
        FlashSalesHeaderWidget(),
        _cargarProductosDescuento
            ? FlashSalesCarouselWidget(
                heroTag: 'home_flash_sales',
                productsList: _publicacioneDescuento)
            : Center(child: CircularProgressIndicator()),
        // Heading (Recommended for you)
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        //   child: ListTile(
        //     dense: true,
        //     contentPadding: EdgeInsets.symmetric(vertical: 0),
        //     leading: Icon(
        //       UiIcons.favorites,
        //       color: Theme.of(context).hintColor,
        //     ),
        //     title: Text(
        //       'Productos',
        //       style: Theme.of(context).textTheme.headline4,
        //     ),
        //   ),
        // ),
        // // StickyHeader(
        // //   header: CategoriesIconsCarouselWidget(
        // //       heroTag: 'home_categories_1',
        // //       publicacion: _productos,
        // //       onChanged: (id) {
        // //         // setState(() {
        // //         //   animationController.reverse().then((f) {
        // //         //     _productsOfCategoryList =
        // //         //         _categoriesList.list!.firstWhere((category) {
        // //         //       return category.id == id;
        // //         //     }).products;
        // //         //     animationController.forward();
        // //         //   });
        // //         // });
        // //       }),
        // //   content: CategorizedProductsWidget(
        // //       animationOpacity: animationOpacity, productsList: _productos),
        // // ),
        // // Heading (Brands)
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
