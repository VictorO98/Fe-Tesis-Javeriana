import 'dart:async';
import 'dart:io';

import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/providers/usuario_provider.dart';
import 'package:Fe_mobile/src/core/util/alert_util.dart';
import 'package:Fe_mobile/src/core/util/estilo_util.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/widgets/ver_imagen_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class FotoUsuarioPage extends StatefulWidget {
  @override
  _FotoUsuarioPageState createState() => _FotoUsuarioPageState();
}

class _FotoUsuarioPageState extends State<FotoUsuarioPage> {
  UsuarioProvider _usuarioProvider = new UsuarioProvider();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _picker = ImagePicker();
  final _prefs = new PreferenciasUtil();

  File? documentoASubir;

  bool _isLoading = false;
  bool isShowImages = false;
  bool isHayImagenSubida = false;

  static const int LIMITE_IMAGENES = 1;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        body: Stack(
          children: <Widget>[
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
      var foto = await _picker.pickImage(source: typeOption);

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

  Widget _crearContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          _crearViewerImagenes(context),
          SizedBox(
            height: 15,
          ),
          _crearBotonSeleccionarGaleria(context),
          _crearBotonTomarFoto(context),
          !_isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton.icon(
                      icon: Icon(Icons.image, color: Colors.white),
                      label: Text("SUBIR FOTO",
                          style: TextStyle(color: Colors.white)),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              EstiloUtil.COLOR_PRIMARY)),
                      onPressed: () {
                        _submitFoto();
                      }))
              : CircularProgressIndicator(),
        ],
      ),
    );
  }

  void _submitFoto() async {
    if (documentoASubir == null) {
      AlertUtil.error(context, "Por favor cargue una imagen. ");
      //setState(() {
      //   isEntregandoEvidencia = false;
      // });
      return;
    }

    List<MultipartFile> listadoFotoUsuario = [];
    listadoFotoUsuario.add(await MultipartFile.fromFile(documentoASubir!.path,
        filename: path.basename(documentoASubir!.path)));

    var correo = await _prefs.getPrefStr("email");

    Map<String, dynamic> data = {"Correo": correo, "files": listadoFotoUsuario};

    setState(() {
      _isLoading = true;
    });
    _usuarioProvider.guardarFotoUsuario(data, context).then((value) {
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
            respuesta: funcionNavegar);
      }
    }).whenComplete(() => setState(() => _isLoading = false));
  }
}
