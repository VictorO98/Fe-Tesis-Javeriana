import 'dart:async';
import 'dart:io';

import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/models/step_manejador_model.dart';
import 'package:Fe_mobile/src/core/util/alert_util.dart';
import 'package:Fe_mobile/src/core/util/currency_util.dart';
import 'package:Fe_mobile/src/core/util/estilo_util.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/core/util/remover_acentos_util.dart';
import 'package:Fe_mobile/src/dominio/models/categoria_model.dart';
import 'package:Fe_mobile/src/dominio/models/crear_publicacion_model.dart';
import 'package:Fe_mobile/src/dominio/providers/contenido_provider.dart';
import 'package:Fe_mobile/src/widgets/DrawerWidget.dart';
import 'package:Fe_mobile/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:Fe_mobile/src/widgets/ver_imagen_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CrearServicioProductoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CrearServicioProductoPageState();
}

class _CrearServicioProductoPageState extends State<CrearServicioProductoPage> {
  CrearPublicacionModel _crearPublicacionModel = new CrearPublicacionModel();
  ContenidoProvider _contenidoProvider = new ContenidoProvider();
  RemoverAcentosUtil _removerAcentosUtil = new RemoverAcentosUtil();

  static const STEP_DATOS_BASICOS = "stepDatosBasicos";
  static const STEP_DATOS_TIEMPOS = "stepDatosTiempos";
  static const STEP_PRECIOS = "stepPrecios";
  static const STEP_IMAGEN = "stepImagen";

  int? _currentStep;

  TextEditingController dateCtl = TextEditingController();
  List<CategoriaModel> _listCategoriaModel = [];
  List<StepManejadorModel> controlSteps = <StepManejadorModel>[];
  List<String> _tipoPublicacion = ["Producto", "Servicio"];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _formDatosBasicos = GlobalKey<FormState>();
  final _formDatosTiempos = GlobalKey<FormState>();
  final _formPrecio = GlobalKey<FormState>();
  final _formImagen = GlobalKey<FormState>();
  final nombresCtrl = TextEditingController();
  final _picker = ImagePicker();
  final _prefs = new PreferenciasUtil();

  double _fontSizeRegrsar = 0;
  double _fontSizeSiguiente = 0;

  late String labelSiguiente;
  late String labelRegresar;

  ButtonStyle? _styleButtonSiguiente;

  File? documentoASubir;

  MediaQueryData? queryData;
  SwiperController? _scrollController;

  CategoriaModel? _categoriaSeleccionada;
  String? _tipoVenta;

  bool _isLoading = false;
  bool checkboxValue = false;
  bool isShowImages = false;
  bool _isModifica = false;
  bool isHayImagenSubida = false;
  late bool _isProducto;

  // TODO cambiar este dato para subir varias
  static const int LIMITE_IMAGENES = 1;

  @override
  void initState() {
    _isProducto = false;
    _scrollController = new SwiperController();
    _scrollController!.addListener(() {});
    _fontSizeRegrsar = 15;
    _fontSizeSiguiente = 15;
    _crearPublicacionModel.descuento = 0;

    _styleButtonSiguiente = TextButton.styleFrom(
        // primary: Colors.black,
        // onSurface: Colors.grey,
        );
    _currentStep = 0;
    labelSiguiente = "SIGUIENTE";
    labelRegresar = "";

    controlSteps.add(new StepManejadorModel(
        formulario: STEP_DATOS_BASICOS,
        numeroStep: 0,
        stepEstado: StepState.editing));
    controlSteps.add(new StepManejadorModel(
        formulario: STEP_DATOS_TIEMPOS,
        numeroStep: 1,
        stepEstado: StepState.editing));
    controlSteps.add(new StepManejadorModel(
        formulario: STEP_PRECIOS,
        numeroStep: 2,
        stepEstado: StepState.editing));
    controlSteps.add(new StepManejadorModel(
        formulario: STEP_IMAGEN, numeroStep: 3, stepEstado: StepState.editing));

    super.initState();
    _getCategorias();
  }

  _getCategorias() async {
    List<CategoriaModel> list = await _contenidoProvider.getAllCategorias();
    setState(() {
      _listCategoriaModel = list;
      _listCategoriaModel.sort((a, b) => a.nombre!.compareTo(b.nombre!));
    });
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
                'Vender',
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
                child: _crearProducto(context))));
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

  List<Step> getStepProductos() {
    return [
      _getFormFieldDatosBasicos(),
      _getFormFieldDatosTiempos(),
      _getFormFieldPrecios(),
      _getFormFieldImagen()
    ];
  }

  Widget _crearProducto(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Form(
          key: _formKey,
          child: Stepper(
            controlsBuilder: (BuildContext context,
                {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
              return !_isLoading
                  ? Row(
                      children: <Widget>[
                        TextButton(
                          onPressed: onStepContinue,
                          child: Text(
                            labelSiguiente,
                            style: TextStyle(fontSize: _fontSizeSiguiente),
                          ),
                          style: _styleButtonSiguiente,
                        ),
                        TextButton(
                            onPressed: onStepCancel,
                            child: Text(
                              labelRegresar,
                              style: TextStyle(fontSize: _fontSizeRegrsar),
                            ))
                      ],
                    )
                  : CircularProgressIndicator();
            },
            steps: getStepProductos(),
            currentStep: this._currentStep!,
            onStepContinue: () => {_gestionarSiguiente(context)},
            onStepCancel: () => {_gestionarRegresar(context)},
            type: StepperType.vertical,
          ),
        ))
      ],
    );
  }

  Step _getFormFieldDatosBasicos() {
    return Step(
      title: Text(
        'Tipo de publicación',
        style: Theme.of(context).textTheme.headline4,
      ),
      subtitle: Text(
        '¿ Que deseas vender ?',
        style: Theme.of(context).textTheme.headline6,
      ),
      isActive: true,
      state: controlSteps
          .firstWhere((element) => element.formulario == STEP_DATOS_BASICOS)
          .stepEstado!,
      content: Form(
        key: _formDatosBasicos,
        child: Column(
          children: <Widget>[
            SizedBox(height: 5),
            DropdownButtonFormField<String>(
              decoration: EstiloUtil.crearInputDecorationFormCustom('',
                  icon: Icon(
                    Icons.shopping_cart,
                    color: EstiloUtil.COLOR_PRIMARY,
                  )),
              value: _tipoVenta,
              items: _tipoPublicacion.map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: new Text(
                    val,
                  ),
                );
              }).toList(),
              validator: (value) =>
                  value == null ? 'Seleccione un tipo de publicación' : null,
              onChanged: (c) => setState(() {
                _tipoVenta = c!;
                _tipoVenta == "Producto"
                    ? _crearPublicacionModel.idtipopublicacion = 1
                    : _crearPublicacionModel.idtipopublicacion = 2;
              }),
            ),

            //   SizedBox(height: 5),
            //
            //
          ],
        ),
      ),
    );
  }

  Step _getFormFieldDatosTiempos() {
    return Step(
        title: Text(
          'Datos basicos',
          style: Theme.of(context).textTheme.headline4,
        ),
        subtitle: Text(
          'Diligencie los datos',
          style: Theme.of(context).textTheme.headline6,
        ),
        isActive: true,
        state: controlSteps
            .firstWhere((element) => element.formulario == STEP_DATOS_TIEMPOS)
            .stepEstado!,
        content: Form(
            key: _formDatosTiempos,
            child: Column(children: <Widget>[
              SizedBox(height: 5),
              TextFormField(
                decoration:
                    EstiloUtil.crearInputDecorationFormCustom("Nombre \*",
                        icon: Icon(
                          Icons.person,
                          color: EstiloUtil.COLOR_PRIMARY,
                        )),
                onSaved: (String? value) {
                  setState(() {
                    _crearPublicacionModel.nombre =
                        _removerAcentosUtil.removeDiacritics(value!);
                  });
                },
                onChanged: (String? value) {
                  setState(() {
                    _crearPublicacionModel.nombre = value;
                  });
                },
                validator: (String? value) =>
                    (value!.isEmpty) || (value.trim().isEmpty)
                        ? 'Registra el nombre de tu publicacion'
                        : null,
              ),
              SizedBox(height: 10),
              _tipoVenta == "Producto"
                  ? TextFormField(
                      onSaved: (String? value) {
                        setState(() {
                          _crearPublicacionModel.cantidadtotal =
                              int.parse(value!);
                        });
                      },
                      onChanged: (String? value) {
                        setState(() {
                          _crearPublicacionModel.cantidadtotal =
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
              SizedBox(height: 10),
              DropdownSearch<CategoriaModel>(
                  mode: Mode.MENU,
                  showSearchBox: true,
                  showClearButton: true,
                  selectedItem: _isModifica ? _categoriaSeleccionada : null,
                  dropdownSearchDecoration:
                      EstiloUtil.crearInputDecorationFormCustom(''),
                  searchBoxDecoration:
                      EstiloUtil.crearInputDecorationFormCustom(''),
                  items: _listCategoriaModel,
                  itemAsString: (CategoriaModel e) => e.nombre!,
                  label: "Categorías \*",
                  hint: "Seleccione la categoría",
                  validator: (value) =>
                      value == null ? 'Seleccione una categoría' : null,
                  onChanged: (c) => setState(() {
                        _crearPublicacionModel.idcategoria = c!.id;
                      })),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.multiline,
                decoration:
                    EstiloUtil.crearInputDecorationFormCustom("Descripción \*",
                        icon: Icon(
                          Icons.text_snippet_rounded,
                          color: EstiloUtil.COLOR_PRIMARY,
                        )),
                onChanged: (String? value) {
                  setState(() {
                    _crearPublicacionModel.descripcion = value;
                  });
                },
                onSaved: (String? value) {
                  setState(() {
                    _crearPublicacionModel.descripcion = value;
                  });
                },
                validator: (String? value) =>
                    (value!.isEmpty) || (value.trim().isEmpty)
                        ? 'Registre la descripción'
                        : null,
              ),
            ])));
  }

  Step _getFormFieldPrecios() {
    return Step(
        title: Text(
          'Precio',
          style: Theme.of(context).textTheme.headline4,
        ),
        subtitle: Text(
          'Diligencie los datos',
          style: Theme.of(context).textTheme.headline6,
        ),
        isActive: true,
        state: controlSteps
            .firstWhere((element) => element.formulario == STEP_PRECIOS)
            .stepEstado!,
        content: Form(
            key: _formPrecio,
            child: Column(children: <Widget>[
              SizedBox(height: 5),
              TextFormField(
                  onSaved: (String? value) {
                    setState(() {
                      _crearPublicacionModel.preciounitario = int.parse(value!);
                    });
                  },
                  onChanged: (String? value) {
                    setState(() {
                      _crearPublicacionModel.preciounitario = int.parse(value!);
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
              _crearPublicacionModel.preciounitario != null
                  ? Text(
                      "${CurrencyUtil.convertFormatMoney('COP', _crearPublicacionModel.preciounitario!)}")
                  : Text("\$0"),
              SizedBox(height: 10),
              TextFormField(
                validator: (String? value) {
                  if (_crearPublicacionModel.descuento != null ||
                      _crearPublicacionModel.descuento != 0) {
                    if (_crearPublicacionModel.descuento! >= 100) {
                      return 'Solo se aceptan valores menores del %100';
                    }
                  }
                  if (_crearPublicacionModel.descuento == null) {}
                },
                onSaved: (String? value) {
                  setState(() {
                    value == ""
                        ? _crearPublicacionModel.descuento = 0
                        : _crearPublicacionModel.descuento = int.parse(value!);
                  });
                },
                onChanged: (String? value) {
                  setState(() {
                    value == ""
                        ? _crearPublicacionModel.descuento = 0
                        : _crearPublicacionModel.descuento = int.parse(value!);
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
              _crearPublicacionModel.descuento != null
                  ? Text("%" + _crearPublicacionModel.descuento.toString())
                  : Text("%0"),
              SizedBox(height: 8),
              CheckboxListTile(
                value: checkboxValue,
                title: Text(
                    "Habilitar trueque (Intercambia tu producto con el de otro emprendedor)"),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    checkboxValue = value!;
                    checkboxValue
                        ? _crearPublicacionModel.habilitatrueque = 1
                        : _crearPublicacionModel.habilitatrueque = 0;
                  });
                },
              )
            ])));
  }

  Step _getFormFieldImagen() {
    return Step(
        title: Text(
          'Imagenes',
          style: Theme.of(context).textTheme.headline4,
        ),
        subtitle: Text(
          'Adjunte las images de su producto',
          style: Theme.of(context).textTheme.headline6,
        ),
        isActive: true,
        state: controlSteps
            .firstWhere((element) => element.formulario == STEP_IMAGEN)
            .stepEstado!,
        content: Form(
            key: _formImagen,
            child: Column(children: <Widget>[
              SizedBox(height: 5),
              _crearViewerImagenes(context),
              _crearBotonSeleccionarGaleria(context),
              _crearBotonTomarFoto(context)
            ])));
  }

  _gestionarSiguiente(BuildContext context) {
    switch (_currentStep) {
      case 0:
        final stepManejador = controlSteps
            .where((element) => element.formulario == STEP_DATOS_BASICOS)
            .first;
        if (_formDatosBasicos.currentState!.validate()) {
          setState(() {
            _currentStep = _currentStep! + 1;
            labelRegresar = "REGRESAR";
            stepManejador.stepEstado = StepState.complete;
          });
        } else {
          setState(() {
            stepManejador.stepEstado = StepState.error;
          });
        }
        break;
      case 1:
        final stepManejador = controlSteps
            .where((element) => element.formulario == STEP_DATOS_TIEMPOS)
            .first;
        if (_formDatosTiempos.currentState!.validate()) {
          setState(() {
            _currentStep = _currentStep! + 1;
            stepManejador.stepEstado = StepState.complete;
          });
        } else {
          setState(() {
            stepManejador.stepEstado = StepState.error;
          });
        }
        break;
      case 2:
        final stepManejador = controlSteps
            .where((element) => element.formulario == STEP_PRECIOS)
            .first;
        if (_formPrecio.currentState!.validate()) {
          setState(() {
            _currentStep = _currentStep! + 1;
            _styleButtonSiguiente = TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: EstiloUtil.COLOR_PRIMARY,
              onSurface: Colors.grey,
            );
            _fontSizeSiguiente = 18;
            _fontSizeRegrsar = 14;
            labelSiguiente = "GUARDAR";
            stepManejador.stepEstado = StepState.complete;
          });
        } else {
          setState(() {
            stepManejador.stepEstado = StepState.error;
          });
        }

        break;
      case 3:
        final stepManejador = controlSteps
            .where((element) => element.formulario == STEP_IMAGEN)
            .first;
        if (_formImagen.currentState!.validate()) {
          setState(() {
            stepManejador.stepEstado = StepState.complete;
            if (documentoASubir != null) {
              _registrarProducto(context);
            } else {
              AlertUtil.error(context, '¡No has anexado imagenes!');
            }
          });
        } else {
          setState(() {
            stepManejador.stepEstado = StepState.error;
          });
        }
        break;
      default:
    }
  }

  _gestionarRegresar(BuildContext context) {
    switch (_currentStep) {
      case 1:
        final stepManejador = controlSteps
            .where((element) => element.formulario == STEP_DATOS_TIEMPOS)
            .first;
        setState(() {
          _currentStep = _currentStep! - 1;
          labelRegresar = "";
          stepManejador.stepEstado = StepState.editing;
        });
        break;
      case 2:
        final stepManejador = controlSteps
            .where((element) => element.formulario == STEP_PRECIOS)
            .first;
        setState(() {
          _currentStep = _currentStep! - 1;
          stepManejador.stepEstado = StepState.editing;
        });
        break;
      case 3:
        final stepManejador = controlSteps
            .where((element) => element.formulario == STEP_IMAGEN)
            .first;
        setState(() {
          _currentStep = _currentStep! - 1;
          labelSiguiente = "SIGUIENTE";
          _styleButtonSiguiente = TextButton.styleFrom();
          _fontSizeSiguiente = 15;
          _fontSizeRegrsar = 15;
          stepManejador.stepEstado = StepState.editing;
        });
        break;
      default:
    }
  }

  _registrarProducto(context) async {
    if (_formDatosBasicos.currentState!.validate() &&
        _formDatosTiempos.currentState!.validate() &&
        _formPrecio.currentState!.validate() &&
        _formImagen.currentState!.validate()) {
      _formDatosBasicos.currentState!.save();
      _formDatosTiempos.currentState!.save();
      _formPrecio.currentState!.save();
      _formImagen.currentState!.save();

      if (documentoASubir == null) {
        AlertUtil.error(context, "Por favor cargue una imagen. ");
        //setState(() {
        //   isEntregandoEvidencia = false;
        // });
        return;
      }

      List<MultipartFile> listadoFotoProductos = [];
      listadoFotoProductos.add(await MultipartFile.fromFile(
          documentoASubir!.path,
          filename: path.basename(documentoASubir!.path)));

      var idUsuario = await _prefs.getPrefStr("id");
      _crearPublicacionModel.idusuario = int.parse(idUsuario!);
      _crearPublicacionModel.tiempoentrega = DateTime.now();
      _crearPublicacionModel.tiempogarantia = DateTime.now();
      _crearPublicacionModel.urlimagenproductoservicio = "";

      if (_crearPublicacionModel.idtipopublicacion == 2)
        _crearPublicacionModel.cantidadtotal = 0;

      if (_crearPublicacionModel.habilitatrueque == null)
        _crearPublicacionModel.habilitatrueque = 0;

      Map<String, dynamic> data = {
        "Idcategoria": _crearPublicacionModel.idcategoria,
        "Idtipopublicacion": _crearPublicacionModel.idtipopublicacion,
        "Idusuario": _crearPublicacionModel.idusuario,
        "Descripcion": _crearPublicacionModel.descripcion,
        "Cantidad": _crearPublicacionModel.cantidadtotal,
        "Precio": _crearPublicacionModel.preciounitario,
        "Descuento": _crearPublicacionModel.descuento,
        "Trueque": _crearPublicacionModel.habilitatrueque,
        "Nombre": _crearPublicacionModel.nombre,
        "files": listadoFotoProductos
      };

      setState(() {
        _isLoading = true;
      });
      _contenidoProvider.guardarPublicacion(data, context).then((value) {
        RespuestaDatosModel? respuesta = value;
        if (respuesta?.codigo == 10) {
          final funcionNavegar = () {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Navigator.of(context).pushNamed(
                '/Tabs',
                arguments: 1,
              );
            });
          };
          AlertUtil.success(context, respuesta!.mensaje!,
              respuesta: funcionNavegar, title: '¡Publicación creada!');
        }
      }).whenComplete(() => setState(() => _isLoading = false));
    }
  }
}
