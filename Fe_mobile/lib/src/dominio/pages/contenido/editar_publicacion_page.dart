import 'dart:async';
import 'dart:io';

import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/util/alert_util.dart';
import 'package:Fe_mobile/src/core/util/currency_util.dart';
import 'package:Fe_mobile/src/core/util/estilo_util.dart';
import 'package:Fe_mobile/src/dominio/models/categoria_model.dart';
import 'package:Fe_mobile/src/dominio/models/crear_publicacion_model.dart';
import 'package:Fe_mobile/src/dominio/models/editar_publicacion_model.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/dominio/providers/contenido_provider.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:Fe_mobile/src/widgets/DrawerWidget.dart';
import 'package:Fe_mobile/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:Fe_mobile/src/widgets/ver_imagen_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditarPublicacionPage extends StatefulWidget {
  RouteArgument? routeArgument;
  ProductoServicioModel? _product;

  EditarPublicacionPage({Key? key, this.routeArgument}) {
    _product = this.routeArgument!.argumentsList![0] as ProductoServicioModel?;
  }

  @override
  _EditarPublicacionPageState createState() => _EditarPublicacionPageState();
}

class _EditarPublicacionPageState extends State<EditarPublicacionPage> {
  EditarPublicacionModel _editarPublicacionModel = new EditarPublicacionModel();
  ContenidoProvider _contenidoProvider = new ContenidoProvider();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formDatosBasicos = GlobalKey<FormState>();
  final _formPrecio = GlobalKey<FormState>();
  final _picker = ImagePicker();

  File? documentoASubir;

  String? _tipoVenta;

  bool isShowImages = false;
  bool isHayImagenSubida = false;
  bool checkboxValue = false;
  bool actualizandoProductos = false;

  //TODO cambiar este dato para subir varias
  static const int LIMITE_IMAGENES = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            key: _scaffoldKey,
            drawer: DrawerWidget(),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              // leading: new IconButton(
              //   icon: new Icon(UiIcons.return_icon,
              //       color: Theme.of(context).hintColor),
              //   onPressed: () => Navigator.of(context).pop(),
              // ),
              leading: new IconButton(
                icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
                onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Editar',
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
                        backgroundImage: AssetImage('img/user3.jpg'),
                      ),
                    )),
              ],
            ),
            body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanDown: (_) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: _editarPublicacion(context))));
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

  _crearBotonSeleccionarGaleria(BuildContext context) {
    return Container(
        alignment: Alignment.center,
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
        alignment: Alignment.center,
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
    if (documentoASubir == null) {
      setState(() {
        isShowImages = false;
      });
      var foto = await _picker.getImage(source: typeOption);

      if (foto != null) {
        File? croppedFile = await ImageCropper.cropImage(
            sourcePath: foto.path,
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
            documentoASubir = croppedFile;
          });
          Timer(Duration(seconds: 2), () {
            setState(() {
              isShowImages = true;
            });
          });
        } else {
          if (documentoASubir != null)
            setState(() {
              isShowImages = true;
            });
        }
      }
    } else {
      AlertUtil.info(context,
          "Solo se puede subir un máximo de $LIMITE_IMAGENES evidencias");
    }
  }

  Widget _crearViewerImagenes(BuildContext context) => SizedBox(
      child: isShowImages
          ? Stack(fit: StackFit.expand, alignment: Alignment.center, children: [
              !isHayImagenSubida ? Image.file(documentoASubir!) : SizedBox(),
              // Image(
              //   fit: BoxFit.cover,
              //   image: !isHayImagenSubida
              //       ? AssetImage(documentoASubir.path)
              //       : _getImagenEvidencia(),
              // ),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                !isHayImagenSubida
                    ? ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent)),
                        onPressed: () {
                          _visualizarImagen();
                        },
                        child:
                            Icon(Icons.more_horiz_sharp, color: Colors.white))
                    : SizedBox(height: 0)
              ])
            ])
          : SizedBox(height: 0.0),
      height: documentoASubir != null && !isHayImagenSubida
          ? MediaQuery.of(context).size.height / 2.7
          : isHayImagenSubida
              ? MediaQuery.of(context).size.height / 1.5
              : MediaQuery.of(context).size.height / 41);

  _visualizarImagen() {
    try {
      if (documentoASubir != null) {
        File file = documentoASubir!;
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new VerImagenWidget(
                    pathImage: file.path, indexImage: 0, callback: callback)));
      }
    } catch (e) {}
  }

  callback(bool isDelete, int index) {
    if (isDelete) {
      //Navigator.pop();
      setState(() {
        isShowImages = false;
      });
      setState(() {
        documentoASubir = null;
      });
      Timer(Duration(seconds: 2), () {
        setState(() {
          isShowImages = true;
        });
      });
    }
  }

  Widget _editarPublicacion(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _crearViewerImagenes(context),
          _crearBotonSeleccionarGaleria(context),
          _crearBotonTomarFoto(context),
          SizedBox(
            height: 10,
          ),
          Text('Información Básica', style: TextStyle(fontSize: 17)),
          Form(
            key: _formDatosBasicos,
            child: Padding(
              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: widget._product!.nombre,
                    decoration:
                        EstiloUtil.crearInputDecorationFormCustom("Nombre \*",
                            icon: Icon(
                              Icons.person,
                              color: EstiloUtil.COLOR_PRIMARY,
                            )),
                    onSaved: (String? value) {
                      setState(() {
                        widget._product!.nombre = value;
                      });
                    },
                    onChanged: (String? value) {
                      setState(() {
                        widget._product!.nombre = value;
                      });
                    },
                    validator: (String? value) =>
                        (value!.isEmpty) || (value.trim().isEmpty)
                            ? 'Registra el nombre de tu publicacion'
                            : null,
                  ),
                  SizedBox(height: 12),
                  widget._product!.tipoPublicacion == "Producto"
                      ? TextFormField(
                          initialValue:
                              widget._product!.cantidadtotal.toString(),
                          onSaved: (String? value) {
                            setState(() {
                              widget._product!.cantidadtotal =
                                  int.parse(value!);
                            });
                          },
                          onChanged: (String? value) {
                            setState(() {
                              widget._product!.cantidadtotal =
                                  int.parse(value!);
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: EstiloUtil.crearInputDecorationFormCustom(
                              'Cantidad disponible \*',
                              icon: Icon(
                                Icons.credit_card,
                                color: EstiloUtil.COLOR_PRIMARY,
                              )),
                          validator: (String? value) {
                            if (value!.isEmpty || value.trim().isEmpty)
                              return 'Registre la cantidad del producto.';

                            if (int.tryParse(value) == null)
                              return 'Solo se aceptan números.';
                            return null;
                          })
                      : SizedBox(),
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: widget._product!.descripcion,
                    keyboardType: TextInputType.multiline,
                    decoration: EstiloUtil.crearInputDecorationFormCustom(
                        "Descripción \*",
                        icon: Icon(
                          Icons.text_snippet_rounded,
                          color: EstiloUtil.COLOR_PRIMARY,
                        )),
                    onChanged: (String? value) {
                      setState(() {
                        widget._product!.descripcion = value;
                      });
                    },
                    onSaved: (String? value) {
                      setState(() {
                        widget._product!.descripcion = value;
                      });
                    },
                    validator: (String? value) =>
                        (value!.isEmpty) || (value.trim().isEmpty)
                            ? 'Registre la descripción'
                            : null,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('Precios', style: TextStyle(fontSize: 17)),
          SizedBox(height: 10),
          Form(
            key: _formPrecio,
            child: Padding(
              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5),
                  TextFormField(
                      initialValue: widget._product!.preciounitario.toString(),
                      onSaved: (String? value) {
                        setState(() {
                          widget._product!.preciounitario = int.parse(value!);
                        });
                      },
                      onChanged: (String? value) {
                        setState(() {
                          widget._product!.preciounitario = int.parse(value!);
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: EstiloUtil.crearInputDecorationFormCustom(
                          'Precio (Sin puntos y comas) \*',
                          icon: Icon(
                            Icons.credit_card,
                            color: EstiloUtil.COLOR_PRIMARY,
                          )),
                      validator: (String? value) {
                        if (value!.isEmpty || value.trim().isEmpty)
                          return 'Registre el precio de tu publicacion';

                        if (int.tryParse(value) == null)
                          return 'Solo se aceptan números.';
                        return null;
                      }),
                  SizedBox(height: 10),
                  widget._product!.preciounitario != null
                      ? Text(
                          "${CurrencyUtil.convertFormatMoney('COP', widget._product!.preciounitario!)}")
                      : Text("\$0"),
                  SizedBox(height: 12),
                  TextFormField(
                    validator: (String? value) {
                      if (widget._product!.descuento != null ||
                          widget._product!.descuento != 0) {
                        if (widget._product!.descuento! >= 100) {
                          return 'Solo se aceptan valores menores del %100';
                        }
                      }
                      if (widget._product!.descuento == null) {}
                    },
                    initialValue:
                        widget._product!.descuento!.toInt().toString(),
                    onSaved: (String? value) {
                      setState(() {
                        value == ""
                            ? widget._product!.descuento = 0
                            : widget._product!.descuento = double.parse(value!);
                      });
                    },
                    onChanged: (String? value) {
                      setState(() {
                        value == ""
                            ? widget._product!.descuento = 0
                            : widget._product!.descuento = double.parse(value!);
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: EstiloUtil.crearInputDecorationFormCustom(
                        'Descuento (%) (Opcional - Sin puntos y comas) \*',
                        icon: Icon(
                          Icons.credit_card,
                          color: EstiloUtil.COLOR_PRIMARY,
                        )),
                  ),
                  SizedBox(height: 8),
                  widget._product!.descuento != null
                      ? Text("%" + widget._product!.descuento.toString())
                      : Text("%0"),
                  SizedBox(height: 8),
                  CheckboxListTile(
                    value: widget._product!.habilitatrueque == 1 ? true : false,
                    title: Text(
                        "Habilitar trueque (Intercambia tu producto con el de otro emprendedor)"),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) {
                      setState(() {
                        checkboxValue = value!;
                        checkboxValue
                            ? widget._product!.habilitatrueque = 1
                            : widget._product!.habilitatrueque = 0;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      AlertUtil.confirm(
                          context,
                          '¿Esta seguro de modificar la publicación ',
                          () => _submit(),
                          confirmBtnText: 'Modificar');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Guardar Cambios',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    if (_formDatosBasicos.currentState!.validate() &&
        _formPrecio.currentState!.validate()) {
      _formDatosBasicos.currentState!.save();
      _formPrecio.currentState!.save();

      _editarPublicacionModel.id = widget._product!.id;
      _editarPublicacionModel.nombre = widget._product!.nombre;
      _editarPublicacionModel.descripcion = widget._product!.descripcion;
      _editarPublicacionModel.cantidadtotal = widget._product!.cantidadtotal;
      _editarPublicacionModel.preciounitario = widget._product!.preciounitario;
      _editarPublicacionModel.descuento = widget._product!.descuento;
      _editarPublicacionModel.habilitatrueque =
          widget._product!.habilitatrueque;

      _contenidoProvider
          .modificarPublicacion(_editarPublicacionModel, context)
          .then((value) {
        RespuestaDatosModel? respuesta = value;
        if (respuesta?.codigo == 10) {
          final funcionNavegar = () async {
            Navigator.pop(context);
            Navigator.of(context).pushNamed('/Tabs', arguments: 1);
          };

          AlertUtil.success(context, respuesta!.mensaje!,
              respuesta: funcionNavegar, title: 'Modificación exitosa!');
        }
      }).whenComplete(() => null);
    }
  }
}
