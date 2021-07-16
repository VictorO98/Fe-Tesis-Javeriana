import 'dart:async';
import 'dart:io';

import 'package:Fe_mobile/src/core/models/departamentos_model.dart';
import 'package:Fe_mobile/src/core/models/municipios_model.dart';
import 'package:Fe_mobile/src/core/models/registro_model.dart';
import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/contract/validar_registro_contract.dart';
import 'package:Fe_mobile/src/core/models/rol_model.dart';
import 'package:Fe_mobile/src/core/models/step_manejador_model.dart';
import 'package:Fe_mobile/src/core/models/tipo_documento_model.dart';
import 'package:Fe_mobile/src/core/pages/usuario/terminos_y_condiciones_page.dart';
import 'package:Fe_mobile/src/core/providers/general_provider.dart';
import 'package:Fe_mobile/src/core/providers/usuario_provider.dart';
import 'package:Fe_mobile/src/core/util/alert_util.dart';
import 'package:Fe_mobile/src/core/util/estilo_util.dart';
import 'package:Fe_mobile/src/widgets/ver_imagen_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  RegistroModel registroModel = new RegistroModel();
  UsuarioProvider _usuarioProvider = new UsuarioProvider();
  GeneralProvider _generalProvider = new GeneralProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  static const STEP_DATOS_PERSONALES = "stepDatosPersonales";
  static const STEP_DATOS_CONTACTO = "stepDatosContacto";
  static const STEP_TIPO_USUARIO = "stepTipousuario";
  static const STEP_PASWWORD = "stepPassword";
  static const CODIGO_PAIS_DEFAULT = 'CO';
  static const CODIGO_TELEFONO_PAIS_DEFAULT = '+57';

  int? _currentStep;

  final _picker = ImagePicker();

  MediaQueryData? queryData;
  SwiperController? _scrollController;

  List<StepManejadorModel> controlSteps = <StepManejadorModel>[];
  List<TipoDocumentoCorModel> listadoTipoDocumento = [];
  List<DepartamentoModel> listDepartamento = [];
  List<MunicipiosModel> listMunicipios = [];
  List<RolModel> listadoRol = [];

  List<File> listadoFotoCedula = [];
  List<File> listadoDocumentoCamaraComercio = [];

  final _formKey = GlobalKey<FormState>();
  final _formDatosPersonales = GlobalKey<FormState>();
  final _formDatosContacto = GlobalKey<FormState>();
  final _formTipoBuya = GlobalKey<FormState>();
  final _formPassword = GlobalKey<FormState>();
  final nombresCtrl = TextEditingController();

  double _fontSizeRegrsar = 0;
  double _fontSizeSiguiente = 0;

  late String labelSiguiente;
  late String labelRegresar;

  ButtonStyle? _styleButtonSiguiente;

  bool _isShowPassword = false;
  bool _isModifica = false;
  bool isShowImageID = false;
  bool isShowImageCC = false;
  late bool isLoadingRegistro;

  MunicipiosModel? _municipioSeleccionado;
  DepartamentoModel? _departamentoSeleccionado;

  static const int LIMITE_IMAGENES = 2;

  @override
  void initState() {
    isLoadingRegistro = false;
    _fontSizeRegrsar = 15;
    _fontSizeSiguiente = 15;
    _styleButtonSiguiente = TextButton.styleFrom(
        // primary: Colors.black,
        // onSurface: Colors.grey,
        );
    _currentStep = 0;
    labelSiguiente = "SIGUIENTE";
    labelRegresar = "";
    registroModel.codigoTelefonoPais = CODIGO_TELEFONO_PAIS_DEFAULT;
    controlSteps.add(new StepManejadorModel(
        formulario: STEP_DATOS_PERSONALES,
        numeroStep: 0,
        stepEstado: StepState.editing));
    controlSteps.add(new StepManejadorModel(
        formulario: STEP_DATOS_CONTACTO,
        numeroStep: 1,
        stepEstado: StepState.editing));
    controlSteps.add(new StepManejadorModel(
        formulario: STEP_TIPO_USUARIO,
        numeroStep: 2,
        stepEstado: StepState.editing));
    controlSteps.add(new StepManejadorModel(
        formulario: STEP_PASWWORD,
        numeroStep: 3,
        stepEstado: StepState.editing));
    super.initState();
    _getDocumentos();
    _getDepartamentos();
    _getRoles();
  }

  _getRoles() async {
    List<RolModel> listado = await _generalProvider.getRoles();
    setState(() {
      listadoRol = listado;
    });
  }

  _getDocumentos() async {
    List<TipoDocumentoCorModel> listado =
        await _generalProvider.getTipoDocumentos();
    setState(() {
      listadoTipoDocumento = listado;
    });
  }

  _getDepartamentos() async {
    List<DepartamentoModel> listado = await _generalProvider.getDepartamentos();
    setState(() {
      listDepartamento = listado;
    });
  }

  _getMunicipios(int? idEstado) async {
    List<MunicipiosModel> listado =
        await _generalProvider.getMunicipioPorIdEstado(idEstado);
    setState(() {
      listMunicipios = listado;
    });
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

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        body: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              margin: EdgeInsets.symmetric(vertical: 65, horizontal: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor.withOpacity(0.6),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              margin: EdgeInsets.symmetric(vertical: 85, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                      offset: Offset(0, 10),
                      blurRadius: 20)
                ],
              ),
              child: WillPopScope(
                  onWillPop: _onWillPop,
                  child: Scaffold(
                      key: _scaffoldKey,
                      body: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanDown: (_) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: _crearContent(context)))),
            ),
          ],
        ));
  }

  List<Step> getStep() {
    return [
      _getFormFieldDatosPersonales(),
      _getFormFieldDatosContacto(),
      _getFormFieldTipoUsuario(),
      _getFormFieldPassword()
    ];
  }

  Widget _crearContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Form(
          key: _formKey,
          child: Stepper(
            controlsBuilder: (BuildContext context,
                {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
              return !isLoadingRegistro
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
            steps: getStep(),
            currentStep: this._currentStep!,
            onStepContinue: () => {_gestionarSiguiente(context)},
            onStepCancel: () => {_gestionarRegresar(context)},
            type: StepperType.vertical,
          ),
        ))
      ],
    );
  }

  _crearBotonSeleccionarGaleria(BuildContext context, int idDoc) {
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
              _gestionFoto(context, ImageSource.gallery, idDoc);
            }));
  }

  _crearBotonTomarFoto(BuildContext context, int idDoc) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton.icon(
            icon: Icon(Icons.camera_alt, color: Colors.white),
            label: Text("TOMAR FOTO", style: TextStyle(color: Colors.white)),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(EstiloUtil.COLOR_PRIMARY)),
            onPressed: () {
              _gestionFoto(context, ImageSource.camera, idDoc);
            }));
  }

  void _gestionFoto(
      BuildContext context, ImageSource typeOption, int idDoc) async {
    if (idDoc == 1) {
      // Listado para la cedula
      if (listadoFotoCedula.length < LIMITE_IMAGENES) {
        setState(() {
          isShowImageID = false;
        });
        var foto = await _picker.getImage(source: typeOption);

        if (foto != null) {
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
              listadoFotoCedula.add(croppedFile);
            });
            Timer(Duration(seconds: 2), () {
              setState(() {
                isShowImageID = true;
              });
            });
          } else {
            if (listadoFotoCedula.length != 0)
              setState(() {
                isShowImageID = true;
              });
          }
        }
      } else {
        AlertUtil.info(context,
            "Solo se puede subir un máximo de $LIMITE_IMAGENES evidencias");
      }
    } else {
      // Listado para la camaria de comercio
      if (listadoDocumentoCamaraComercio.length < LIMITE_IMAGENES) {
        setState(() {
          isShowImageCC = false;
        });
        var foto = await _picker.getImage(source: typeOption);

        if (foto != null) {
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
              listadoDocumentoCamaraComercio.add(croppedFile);
            });
            Timer(Duration(seconds: 2), () {
              setState(() {
                isShowImageCC = true;
              });
            });
          } else {
            if (listadoDocumentoCamaraComercio.length != 0)
              setState(() {
                isShowImageCC = true;
              });
          }
        }
      } else {
        AlertUtil.info(context,
            "Solo se puede subir un máximo de $LIMITE_IMAGENES evidencias");
      }
    }
  }

  Widget _crearViewerImagenes(BuildContext context, int idDoc) {
    return idDoc == 1
        ? SizedBox(
            child: isShowImageID
                ? new Swiper(
                    scrollDirection: Axis.horizontal,
                    pagination: new SwiperPagination(),
                    controller: _scrollController,
                    itemCount: listadoFotoCedula.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: [
                            // Image(
                            //   fit: BoxFit.cover,
                            //   image: AssetImage(listadoFotoEvidencia[index].path),
                            // ),
                            Image.file(listadoFotoCedula[index]),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.transparent)),
                                      onPressed: () {
                                        idDoc == 1
                                            ? _visualizarImagenID(index)
                                            : _visualizarImagenCC(index);
                                      },
                                      child: Icon(Icons.more_horiz_sharp,
                                          color: Colors.white))
                                ])
                          ]);
                    })
                : SizedBox(height: 0.0),
            height: listadoFotoCedula.length > 0 ? 300.0 : 20,
          )
        : SizedBox(
            child: isShowImageCC
                ? new Swiper(
                    scrollDirection: Axis.horizontal,
                    pagination: new SwiperPagination(),
                    controller: _scrollController,
                    itemCount: listadoDocumentoCamaraComercio.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: [
                            // Image(
                            //   fit: BoxFit.cover,
                            //   image: AssetImage(listadoFotoEvidencia[index].path),
                            // ),
                            Image.file(listadoDocumentoCamaraComercio[index]),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.transparent)),
                                      onPressed: () {
                                        idDoc == 1
                                            ? _visualizarImagenID(index)
                                            : _visualizarImagenCC(index);
                                      },
                                      child: Icon(Icons.more_horiz_sharp,
                                          color: Colors.white))
                                ])
                          ]);
                    })
                : SizedBox(height: 0.0),
            height: listadoDocumentoCamaraComercio.length > 0 ? 300.0 : 20,
          );
  }

  _visualizarImagenID(int index) {
    try {
      if (listadoFotoCedula.length > 0) {
        File file = listadoFotoCedula[index];
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new VerImagenWidget(
                    pathImage: file.path,
                    indexImage: index,
                    callback: callbackID)));
      }
    } catch (e) {}
  }

  callbackID(bool isDelete, int index) {
    if (isDelete) {
      Navigator.of(context).pop();
      setState(() {
        isShowImageID = false;
      });
      setState(() {
        listadoFotoCedula.removeAt(index);
      });
      Timer(Duration(seconds: 2), () {
        setState(() {
          isShowImageID = true;
        });
      });
    }
  }

  _visualizarImagenCC(int index) {
    try {
      if (listadoDocumentoCamaraComercio.length > 0) {
        File file = listadoDocumentoCamaraComercio[index];
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new VerImagenWidget(
                    pathImage: file.path,
                    indexImage: index,
                    callback: callbackCC)));
      }
    } catch (e) {}
  }

  callbackCC(bool isDelete, int index) {
    if (isDelete) {
      Navigator.of(context).pop();
      setState(() {
        isShowImageCC = false;
      });
      setState(() {
        listadoDocumentoCamaraComercio.removeAt(index);
      });
      Timer(Duration(seconds: 2), () {
        setState(() {
          isShowImageCC = true;
        });
      });
    }
  }

  Step _getFormFieldDatosPersonales() {
    return Step(
        title: const Text(
          'Datos personales',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Diligencie los datos personales',
          style: TextStyle(fontSize: 15),
        ),
        isActive: true,
        state: controlSteps
            .firstWhere(
                (element) => element.formulario == STEP_DATOS_PERSONALES)
            .stepEstado!,
        content: Form(
          key: _formDatosPersonales,
          child: Column(
            children: <Widget>[
              SizedBox(height: 5),
              TextFormField(
                decoration:
                    EstiloUtil.crearInputDecorationFormCustom("Nombres \*",
                        icon: Icon(
                          Icons.person,
                          color: EstiloUtil.COLOR_PRIMARY,
                        )),
                onSaved: (String? value) {
                  setState(() {
                    registroModel.nombres = value;
                  });
                },
                validator: (String? value) =>
                    (value!.isEmpty) || (value.trim().isEmpty)
                        ? 'Registre su nombre'
                        : null,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  onSaved: (String? value) {
                    setState(() {
                      registroModel.apellidos = value;
                    });
                  },
                  decoration:
                      EstiloUtil.crearInputDecorationFormCustom('Apellidos \*',
                          icon: Icon(
                            Icons.person,
                            color: EstiloUtil.COLOR_PRIMARY,
                          )),
                  validator: (String? value) =>
                      (value!.isEmpty) || (value.trim().isEmpty)
                          ? 'Registre sus apellidos'
                          : null),
              SizedBox(
                height: 15,
              ),
              DropdownButtonFormField<String>(
                  decoration: EstiloUtil.crearInputDecorationFormCustom('',
                      icon: Icon(
                        Icons.credit_card,
                        color: EstiloUtil.COLOR_PRIMARY,
                      )),
                  value: registroModel.idTipoDocumentoStr,
                  items: listadoTipoDocumento.map((e) {
                    return DropdownMenuItem(
                      value: e.id.toString(),
                      child: new Text("${e.nombre}"),
                    );
                  }).toList(),
                  hint: Text("Tipo de documento \*"),
                  onSaved: (val) {
                    setState(() {
                      registroModel.idTipoDocumentoStr = val;
                    });
                  },
                  onChanged: (val) {
                    setState(() {
                      registroModel.idTipoDocumentoStr = val;
                    });
                  },
                  validator: (value) => value == null //|| value == 0
                      ? 'Seleccione el tipo de documento'
                      : null),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  onSaved: (String? value) {
                    setState(() {
                      registroModel.numeroDocumento = value;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: EstiloUtil.crearInputDecorationFormCustom(
                      'Número de identificación \*',
                      icon: Icon(
                        Icons.credit_card,
                        color: EstiloUtil.COLOR_PRIMARY,
                      )),
                  validator: (String? value) {
                    if (value!.isEmpty || value.trim().isEmpty)
                      return 'Registre su número de identificación.';

                    if (int.tryParse(value) == null)
                      return 'Solo se aceptan números.';
                    return null;
                  }),
            ],
          ),
        ));
  }

  Step _getFormFieldDatosContacto() {
    return Step(
        isActive: false,
        state: controlSteps
            .firstWhere((element) => element.formulario == STEP_DATOS_CONTACTO)
            .stepEstado!,
        title: const Text('Datos de contacto',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(
          "Diligencie los datos de contacto.",
          style: TextStyle(fontSize: 15),
        ),
        content: Form(
            key: _formDatosContacto,
            child: Column(children: <Widget>[
              SizedBox(
                height: 5,
              ),
              TextFormField(
                  onSaved: (String? value) {
                    setState(() {
                      registroModel.email = value;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: EstiloUtil.crearInputDecorationFormCustom(
                      'Correo electrónico \*',
                      icon: Icon(
                        Icons.email,
                        color: EstiloUtil.COLOR_PRIMARY,
                      )),
                  validator: (String? value) =>
                      (value!.isEmpty) || (value.trim().isEmpty)
                          ? 'Registre su correo electrónico'
                          : !EmailValidator.validate(value)
                              ? 'El formato del correo es incorrecto'
                              : null),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  onSaved: (String? value) {
                    setState(() {
                      registroModel.direccion = value;
                    });
                  },
                  decoration: EstiloUtil.crearInputDecorationFormCustom(
                      'Dirección de entregas \*',
                      icon: Icon(
                        Icons.home,
                        color: EstiloUtil.COLOR_PRIMARY,
                      )),
                  validator: (String? value) =>
                      (value!.isEmpty) || (value.trim().isEmpty)
                          ? 'Registre su dirección de entrega'
                          : null),
              SizedBox(
                height: 15,
              ),
              DropdownSearch<DepartamentoModel>(
                  mode: Mode.MENU,
                  showSearchBox: true,
                  showClearButton: true,
                  selectedItem: _isModifica ? _departamentoSeleccionado : null,
                  dropdownSearchDecoration:
                      EstiloUtil.crearInputDecorationFormCustom(''),
                  searchBoxDecoration:
                      EstiloUtil.crearInputDecorationFormCustom(''),
                  items: listDepartamento,
                  itemAsString: (DepartamentoModel e) => e.nombre!,
                  label: "Departamento \*",
                  hint: "Seleccione el departamento",
                  validator: (value) =>
                      value == null ? 'Seleccione el departamento' : null,
                  onBeforeChange: (prevItem, nextItem) async {
                    print("A0 - ${prevItem?.nombre} - $nextItem");
                    _departamentoSeleccionado = nextItem;
                    _municipioSeleccionado = null;
                    return true;
                  },
                  onChanged: (e) {
                    _getMunicipios(e?.id);
                  })
              // decoration: EstiloUtil.crearInputDecorationFormCustom('',
              //     icon: Icon(
              //       Icons.credit_card,
              //       color: EstiloUtil.COLOR_PRIMARY,
              //     )),
              ,
              SizedBox(
                height: 15,
              ),
              DropdownSearch<MunicipiosModel>(
                  mode: Mode.MENU,
                  showSearchBox: true,
                  showClearButton: true,
                  selectedItem: _isModifica ? _municipioSeleccionado : null,
                  dropdownSearchDecoration:
                      EstiloUtil.crearInputDecorationFormCustom(''),
                  searchBoxDecoration:
                      EstiloUtil.crearInputDecorationFormCustom(''),
                  items: listMunicipios,
                  itemAsString: (MunicipiosModel e) => e.nombre!,
                  onBeforeChange: (prevItem, nextItem) async {
                    _municipioSeleccionado = nextItem;
                    return true;
                  },
                  label: "Ciudad \*",
                  hint: "Selecciona la ciudad",
                  validator: (value) =>
                      value == null ? 'Seleccione la ciudad' : null,
                  onChanged: (c) => setState(() {
                        registroModel.idPoblacion = c?.id.toString();
                      })),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  onSaved: (String? value) {
                    setState(() {
                      registroModel.numeroTelefonico = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Teléfono \*',
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.pinkAccent),
                      ),
                      icon: CountryCodePicker(
                        onChanged: (val) {
                          setState(() {
                            // registroModel.codigoTelefonoPais = val.dialCode;
                          });
                        },
                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: CODIGO_PAIS_DEFAULT,
                        favorite: [
                          CODIGO_TELEFONO_PAIS_DEFAULT,
                          CODIGO_PAIS_DEFAULT
                        ],
                        // optional. Shows only country name and flag
                        showCountryOnly: false,
                        // optional. Shows only country name and flag when popup is closed.
                        showOnlyCountryWhenClosed: false,
                        // optional. aligns the flag and the Text left
                        alignLeft: false,
                      )),
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  validator: (String? value) {
                    if (value!.isEmpty || value.trim().isEmpty)
                      return 'Registre su número de teléfono';

                    if (int.tryParse(value) == null)
                      return 'Solo se aceptan números.';
                    return null;
                  }),
            ])));
  }

  Step _getFormFieldTipoUsuario() {
    return Step(
        state: controlSteps
            .firstWhere((element) => element.formulario == STEP_TIPO_USUARIO)
            .stepEstado!,
        title: const Text(
          'Tipo de usuario',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Seleccione el tipo de usuario de su preferencia",
          style: TextStyle(fontSize: 15),
        ),
        content: Form(
            key: _formTipoBuya,
            child: Column(children: <Widget>[
              Text(
                "El emprendedor distribuye sus productos o servicio en la plataforma. Tiene la posibilidad de vender, comprar y realizar trueques\n\n¡Para ser emprendedor es necesario registrar un producto o servicio!",
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                  "El usuario tiene la posibilidad de realizar compras en la plataforma a los emprendedores.",
                  style: TextStyle(fontSize: 17)),
              SizedBox(
                height: 15,
              ),
              DropdownButtonFormField(
                decoration: EstiloUtil.crearInputDecorationFormCustom(''),
                value: registroModel.idTipoClienteStr,
                items: listadoRol.map((e) {
                  return DropdownMenuItem(
                    value: e.id.toString(),
                    child: new Text("${e.nombre}"),
                  );
                }).toList(),
                hint: Text("Seleccionar el tipo de usuario \*"),
                onSaved: (dynamic val) {
                  setState(() {
                    registroModel.idTipoClienteStr = val;
                  });
                },
                validator: (dynamic value) => value == null || value == 0
                    ? 'Seleccione el tipo de usuario'
                    : null,
                onChanged: (Object? val) {
                  setState(() {
                    registroModel.idTipoClienteStr = val as String?;
                  });
                },
              ),
              registroModel.idTipoClienteStr == "2"
                  ? Column(children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onSaved: (String? value) {
                          setState(() {
                            //registroModel.direccion = value;
                          });
                        },
                        decoration: EstiloUtil.crearInputDecorationFormCustom(
                            'Nombre razón social',
                            icon: Icon(
                              Icons.home,
                              color: EstiloUtil.COLOR_PRIMARY,
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Adjunta tú documento de identificación",
                          style: TextStyle(fontSize: 17)),
                      SizedBox(
                        height: 5,
                      ),
                      _crearViewerImagenes(context, 1),
                      _crearBotonSeleccionarGaleria(context, 1),
                      _crearBotonTomarFoto(context, 1),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          "Adjunta el registro de camara de comercio (Si aplica)",
                          style: TextStyle(fontSize: 17)),
                      SizedBox(
                        height: 10,
                      ),
                      _crearViewerImagenes(context, 2),
                      _crearBotonSeleccionarGaleria(context, 2),
                      _crearBotonTomarFoto(context, 2)
                    ])
                  : SizedBox(height: 0)
            ])));
  }

  Step _getFormFieldPassword() {
    return Step(
        isActive: false,
        state: controlSteps
            .firstWhere((element) => element.formulario == STEP_PASWWORD)
            .stepEstado!,
        title: const Text('Contraseña',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(
          "Registre la contraseña.",
          style: TextStyle(fontSize: 15),
        ),
        content: Form(
            key: _formPassword,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "La contraseña debe contener mínimo 8 caracteres.",
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    onSaved: (String? value) {
                      setState(() {
                        registroModel.password = value;
                      });
                    },
                    obscureText: !_isShowPassword,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: EstiloUtil.crearInputDecorationFormCustom(
                        'Contraseña \*',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () => setState(
                                () => _isShowPassword = !_isShowPassword))),
                    validator: (value) {
                      if (value!.isEmpty || (value.trim().isEmpty)) {
                        if (value.length < 8) {
                          return "La contraseña es muy corta";
                        }
                        return 'Registre la contraseña';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    onSaved: (String? value) {
                      setState(() {
                        registroModel.confirmPassword = value;
                      });
                    },
                    obscureText: !_isShowPassword,
                    decoration: EstiloUtil.crearInputDecorationFormCustom(
                        'Confirmar contraseña \*',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () => setState(
                                () => _isShowPassword = !_isShowPassword))),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value!.isEmpty || (value.trim().isEmpty)) {
                        if (value.length < 8) {
                          return "La contraseña es muy corta";
                        }
                        return 'Confirme la contraseña';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Al registrarse aceptará los terminos y condiciones",
                      style: TextStyle(fontSize: 16)),
                  TextButton(
                      child: Text("Términos y condiciones",
                          style: TextStyle(color: EstiloUtil.COLOR_DARK)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    TerminosYCondicionesPage()));
                      }),
                  SizedBox(
                    height: 10,
                  )
                ])));
  }

  _gestionarSiguiente(BuildContext context) {
    switch (_currentStep) {
      case 0:
        final stepManejador = controlSteps
            .where((element) => element.formulario == STEP_DATOS_PERSONALES)
            .first;
        if (_formDatosPersonales.currentState!.validate()) {
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
            .where((element) => element.formulario == STEP_DATOS_CONTACTO)
            .first;
        if (_formDatosContacto.currentState!.validate()) {
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
            .where((element) => element.formulario == STEP_TIPO_USUARIO)
            .first;
        if (registroModel.idTipoClienteStr == "2" &&
            listadoFotoCedula.length != 0) {
          if (_formTipoBuya.currentState!.validate()) {
            setState(() {
              _currentStep = _currentStep! + 1;
              _styleButtonSiguiente = TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: EstiloUtil.COLOR_PRIMARY,
                onSurface: Colors.grey,
              );
              _fontSizeSiguiente = 18;
              _fontSizeRegrsar = 14;
              labelSiguiente = "REGISTRAR";
              stepManejador.stepEstado = StepState.complete;
            });
          } else {
            setState(() {
              stepManejador.stepEstado = StepState.error;
            });
          }
        } else {
          registroModel.idTipoClienteStr == "3"
              ? SizedBox()
              : AlertUtil.error(
                  context, "Debes adjuntar tu documento de identificación");
        }
        if (registroModel.idTipoClienteStr == "3") {
          if (_formTipoBuya.currentState!.validate()) {
            setState(() {
              _currentStep = _currentStep! + 1;
              _styleButtonSiguiente = TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: EstiloUtil.COLOR_PRIMARY,
                onSurface: Colors.grey,
              );
              _fontSizeSiguiente = 18;
              _fontSizeRegrsar = 14;
              labelSiguiente = "REGISTRAR";
              stepManejador.stepEstado = StepState.complete;
            });
          } else {
            setState(() {
              stepManejador.stepEstado = StepState.error;
            });
          }
        }
        break;
      case 3:
        final stepManejador = controlSteps
            .where((element) => element.formulario == STEP_PASWWORD)
            .first;
        if (_formPassword.currentState!.validate()) {
          setState(() {
            stepManejador.stepEstado = StepState.complete;
            _registrarUsuario(context);
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
            .where((element) => element.formulario == STEP_DATOS_CONTACTO)
            .first;
        setState(() {
          _currentStep = _currentStep! - 1;
          labelRegresar = "";
          stepManejador.stepEstado = StepState.editing;
        });
        break;
      case 2:
        final stepManejador = controlSteps
            .where((element) => element.formulario == STEP_TIPO_USUARIO)
            .first;
        setState(() {
          _currentStep = _currentStep! - 1;
          stepManejador.stepEstado = StepState.editing;
        });
        break;
      case 3:
        final stepManejador = controlSteps
            .where((element) => element.formulario == STEP_PASWWORD)
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

  void _registrarUsuario(BuildContext context) async {
    if (_formDatosPersonales.currentState!.validate() &&
        _formDatosContacto.currentState!.validate() &&
        _formTipoBuya.currentState!.validate() &&
        _formPassword.currentState!.validate()) {
      _formDatosPersonales.currentState!.save();
      _formDatosContacto.currentState!.save();
      _formTipoBuya.currentState!.save();
      _formPassword.currentState!.save();
      registroModel.isAceptaTerminosYCondiciones = true;
      registroModel.idTipoCliente =
          int.parse(registroModel.idTipoClienteStr ?? '0');
      registroModel.idTipoDocumento =
          int.parse(registroModel.idTipoDocumentoStr ?? '0');
      registroModel.isAceptaTerminosYCondiciones = true;
      setState(() {
        isLoadingRegistro = true;
      });
      _usuarioProvider.registrarUsuario(registroModel, context).then((value) {
        RespuestaDatosModel? respuesta = value;
        if (respuesta?.codigo == 10) {
          final funcionNavegar = () {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "login", (Route<dynamic> route) => false,
                  arguments: new ValidaRegistroContract(isRegistro: true));
            });
          };
          AlertUtil.success(context, respuesta!.mensaje!,
              respuesta: funcionNavegar, title: '¡Registro exitoso!');
        }
      }).whenComplete(() => setState(() => isLoadingRegistro = false));
    }
  }
}
