import 'dart:async';
import 'dart:io';

import 'package:Fe_mobile/src/core/util/alert_util.dart';
import 'package:Fe_mobile/src/core/util/estilo_util.dart';
import 'package:Fe_mobile/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:Fe_mobile/src/widgets/ver_imagen_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CrearServicioProductoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CrearServicioProductoPageState();
}

class _CrearServicioProductoPageState extends State<CrearServicioProductoPage> {
  List<File> listadoFotoProductos = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formProductoServicio = GlobalKey<FormState>();
  final _picker = ImagePicker();

  MediaQueryData? queryData;
  SwiperController? _scrollController;

  int _tipoPublicacion = 0;
  int _estadoInfoProducto = 0;

  bool _isLoading = false;
  bool isShowImages = false;

  static const int LIMITE_IMAGENES = 5;

  @override
  void initState() {
    _scrollController = new SwiperController();
    _scrollController!.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: _isLoading ? Colors.white : Colors.lightBlue[100],
          key: _scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: new IconButton(
              icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Producto o Servicio',
              style: Theme.of(context).textTheme.headline4,
            ),
            actions: <Widget>[
              new ShoppingCartButtonWidget(
                  iconColor: Theme.of(context).hintColor,
                  labelColor: Theme.of(context).accentColor),
              Container(
                  width: 30,
                  height: 30,
                  margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(300),
                    onTap: () {
                      Navigator.of(context).pushNamed('/Tabs', arguments: 1);
                    },
                    child: CircleAvatar(
                      backgroundImage: AssetImage('img/user2.jpg'),
                    ),
                  )),
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              // controller: controller,
              child: _tipoPublicacion == 0
                  ? Column(
                      children: <Widget>[_createProductService(context)],
                    )
                  : _tipoPublicacion == 1
                      ? _isLoading
                          ? Column(
                              children: <Widget>[
                                _crearViewerImagenes(context),
                                _crearProducto(context)
                              ],
                            )
                          : Center(child: CircularProgressIndicator())
                      : _isLoading
                          ? Column(
                              children: <Widget>[
                                _crearViewerImagenes(context),
                                _crearServicio(context)
                              ],
                            )
                          : Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await (showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('¿Se encuentra seguro?'),
            content: new Text(
                'Tiene cambios pendientes, ¿está seguro de que desea descartarlos?'),
            actions: <Widget>[
              new ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Si'),
              ),
            ],
          ),
        )) ??
        false);
  }

  Widget _createProductService(BuildContext context) {
    queryData = MediaQuery.of(context);
    var widthScreen = queryData!.size.width;
    var heightScreen = queryData!.size.height;

    return Container(
        alignment: Alignment.center,
        child: Form(
            key: _formProductoServicio,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 45,
                ),
                Text("¿Qué quieres publicar?",
                    style: Theme.of(context).textTheme.headline3),
                SizedBox(
                  height: 45,
                ),
                ClipOval(
                  child: Material(
                    color: Colors.white, // Button color
                    child: InkWell(
                      splashColor: Colors.limeAccent, // Splash color
                      onTap: () {
                        _tipoPublicacion = 1;
                        setState(() {});
                        Timer(Duration(seconds: 1), () {
                          setState(() {
                            _isLoading = true;
                          });
                        });
                      },
                      child: SizedBox(
                          width: heightScreen / 5.3,
                          height: heightScreen / 5.3,
                          child: Icon(Icons.watch,
                              color: Colors.lightBlue,
                              size: heightScreen / 12)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text("Producto", style: Theme.of(context).textTheme.headline4),
                SizedBox(height: 35),
                ClipOval(
                  child: Material(
                    color: Colors.white, // Button color
                    child: InkWell(
                      splashColor: Colors.limeAccent, // Splash color
                      onTap: () {
                        _tipoPublicacion = 2;
                        setState(() {});
                        Timer(Duration(seconds: 1), () {
                          setState(() {
                            _isLoading = true;
                          });
                        });
                      },
                      child: SizedBox(
                          width: heightScreen / 5.3,
                          height: heightScreen / 5.3,
                          child: Icon(Icons.dry_cleaning,
                              color: Colors.lightBlue,
                              size: heightScreen / 12)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text("Servicio", style: Theme.of(context).textTheme.headline4)
              ],
            )
            // Column(
            //   children: [
            //     SizedBox(height: 15),
            //     DropdownButtonFormField<String>(
            //         decoration: EstiloUtil.crearInputDecorationFormCustom('',
            //             icon: Icon(
            //               Icons.credit_card,
            //               color: EstiloUtil.COLOR_PRIMARY,
            //             )),
            //         value: null,
            //         items: ["Producto", "Servicio"]
            //             .map((label) => DropdownMenuItem(
            //                   child: Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceAround,
            //                     children: <Widget>[
            //                       Image.asset(
            //                         'icons/currency/${label.toLowerCase()}.png',
            //                         package: 'currency_icons',
            //                         width: 30,
            //                       ),
            //                       Text(label),
            //                     ],
            //                   ),
            //                   value: label,
            //                 ))
            //             .toList(),
            //         hint: Text("Tipo de documento \*"),
            //         onSaved: (val) {
            //           setState(() {
            //             //registroModel.idTipoDocumentoStr = val;
            //           });
            //         },
            //         onChanged: (val) {
            //           setState(() {
            //             //registroModel.idTipoDocumentoStr = val;
            //           });
            //         },
            //         validator: (value) => value == null //|| value == 0
            //             ? 'Seleccione el tipo de documento'
            //             : null),

            ));
  }

  _crearBotonSeleccionarGaleria(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton.icon(
            icon: Icon(Icons.image, color: Colors.white),
            label: Text("SELECCIONAR FOTOS DE GALERÍA",
                style: TextStyle(color: Colors.white)),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(EstiloUtil.COLOR_PRIMARY)),
            onPressed: () {
              _gestionFoto(context, ImageSource.gallery);
            }));
  }

  _crearBotonTomarFoto(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton.icon(
            icon: Icon(Icons.camera_alt, color: Colors.white),
            label: Text("TOMAR FOTO", style: TextStyle(color: Colors.white)),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(EstiloUtil.COLOR_PRIMARY)),
            onPressed: () {
              _gestionFoto(context, ImageSource.camera);
            }));
  }

  void _gestionFoto(BuildContext context, ImageSource typeOption) async {
    if (listadoFotoProductos.length < LIMITE_IMAGENES) {
      setState(() {
        isShowImages = false;
      });
      var foto = await _picker.getImage(source: typeOption);

      File? croppedFile = await ImageCropper.cropImage(
          sourcePath: foto?.path ?? '',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Editar imagen',
              toolbarColor: EstiloUtil.COLOR_PRIMARY,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              backgroundColor: EstiloUtil.COLOR_CLEAR,
              statusBarColor: EstiloUtil.COLOR_PRIMARY,
              cropFrameColor: EstiloUtil.COLOR_PRIMARY,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

      if (croppedFile != null) {
        setState(() {
          listadoFotoProductos.add(croppedFile);
        });
        Timer(Duration(seconds: 2), () {
          setState(() {
            isShowImages = true;
          });
        });
      } else {
        if (listadoFotoProductos.length != 0)
          setState(() {
            isShowImages = true;
          });
      }
    } else {
      AlertUtil.info(context,
          "Solo se puede subir un máximo de $LIMITE_IMAGENES evidencias");
    }
  }

  Widget _crearViewerImagenes(BuildContext context) {
    return SizedBox(
      child: isShowImages
          ? new Swiper(
              scrollDirection: Axis.horizontal,
              pagination: new SwiperPagination(),
              controller: _scrollController,
              itemCount: listadoFotoProductos.length,
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      // Image(
                      //   fit: BoxFit.cover,
                      //   image: AssetImage(listadoFotoEvidencia[index].path),
                      // ),
                      Image.file(listadoFotoProductos[index]),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.transparent)),
                                onPressed: () {
                                  _visualizarImagen(index);
                                },
                                child: Icon(Icons.more_horiz_sharp,
                                    color: Colors.white))
                          ])
                    ]);
              })
          : SizedBox(height: 0.0),
      height: listadoFotoProductos.length > 0 ? 300.0 : 20,
    );
  }

  _visualizarImagen(int index) {
    try {
      if (listadoFotoProductos.length > 0) {
        File file = listadoFotoProductos[index];
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new VerImagenWidget(
                    pathImage: file.path,
                    indexImage: index,
                    callback: callback)));
      }
    } catch (e) {}
  }

  callback(bool isDelete, int index) {
    if (isDelete) {
      Navigator.of(context).pop();
      setState(() {
        isShowImages = false;
      });
      setState(() {
        listadoFotoProductos.removeAt(index);
      });
      Timer(Duration(seconds: 2), () {
        setState(() {
          isShowImages = true;
        });
      });
    }
  }

  Widget _crearProducto(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.center,
        child: Form(
            key: _formProductoServicio,
            child: Column(
              children: [
                SizedBox(height: 20),
                _crearBotonSeleccionarGaleria(context),
                _crearBotonTomarFoto(context),
                SizedBox(height: 5),
                TextFormField(
                  decoration: EstiloUtil.crearInputDecorationFormCustom(
                      "Nombre producto \*",
                      icon: Icon(
                        Icons.person,
                        color: EstiloUtil.COLOR_PRIMARY,
                      )),
                  onSaved: (String? value) {
                    setState(() {
                      //registroModel.nombres = value;
                    });
                  },
                  validator: (String? value) =>
                      (value!.isEmpty) || (value.trim().isEmpty)
                          ? 'Registre el nombre del producto'
                          : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                    keyboardType: TextInputType.number,
                    decoration:
                        EstiloUtil.crearInputDecorationFormCustom("Cantidad \*",
                            icon: Icon(
                              Icons.person,
                              color: EstiloUtil.COLOR_PRIMARY,
                            )),
                    onSaved: (String? value) {
                      setState(() {
                        //registroModel.nombres = value;
                      });
                    },
                    validator: (String? value) {
                      if (value!.isEmpty || value.trim().isEmpty)
                        return 'Registre la cantidad del producto.';

                      if (int.tryParse(value) == null)
                        return 'Solo se aceptan números.';
                      return null;
                    }),
                SizedBox(height: 10),
                TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: EstiloUtil.crearInputDecorationFormCustom(
                        "Precio unitario (Sin puntos y comas) \*",
                        icon: Icon(
                          Icons.person,
                          color: EstiloUtil.COLOR_PRIMARY,
                        )),
                    onSaved: (String? value) {
                      setState(() {
                        //registroModel.nombres = value;
                      });
                    },
                    validator: (String? value) {
                      if (value!.isEmpty || value.trim().isEmpty)
                        return 'Registre la cantidad del producto.';

                      if (int.tryParse(value) == null)
                        return 'Solo se aceptan números.';
                      return null;
                    }),
                SizedBox(height: 10),
                TextFormField(
                  decoration: EstiloUtil.crearInputDecorationFormCustom(
                      "Descripción \*",
                      icon: Icon(
                        Icons.person,
                        color: EstiloUtil.COLOR_PRIMARY,
                      )),
                  onSaved: (String? value) {
                    setState(() {
                      //registroModel.nombres = value;
                    });
                  },
                  validator: (String? value) =>
                      (value!.isEmpty) || (value.trim().isEmpty)
                          ? 'Registre la descripción del producto'
                          : null,
                ),
              ],
            )));
  }

  Widget _crearServicio(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Form(
            key: _formProductoServicio,
            child: Column(
              children: [
                SizedBox(height: 20),
                TextFormField(
                  decoration: EstiloUtil.crearInputDecorationFormCustom(
                      "Nombre Servicio \*",
                      icon: Icon(
                        Icons.person,
                        color: EstiloUtil.COLOR_PRIMARY,
                      )),
                  onSaved: (String? value) {
                    setState(() {
                      //registroModel.nombres = value;
                    });
                  },
                  validator: (String? value) =>
                      (value!.isEmpty) || (value.trim().isEmpty)
                          ? 'Registre el nombre del producto o del servicio'
                          : null,
                ),
              ],
            )));
  }
}
