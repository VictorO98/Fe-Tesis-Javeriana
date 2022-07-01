import 'package:Fe_mobile/src/core/models/departamentos_model.dart';
import 'package:Fe_mobile/src/core/models/info_usuario_model.dart';
import 'package:Fe_mobile/src/core/models/modificar_demografia_model.dart';
import 'package:Fe_mobile/src/core/models/municipios_model.dart';
import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/pages/usuario/bloc/info_perfil/info_usuario_bloc.dart';
import 'package:Fe_mobile/src/core/providers/general_provider.dart';
import 'package:Fe_mobile/src/core/providers/usuario_provider.dart';
import 'package:Fe_mobile/src/core/util/alert_util.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class ProfileSettingsDialog extends StatefulWidget {
  InfoUsuarioModel? user;
  VoidCallback? onChanged;

  ProfileSettingsDialog({Key? key, this.user, this.onChanged})
      : super(key: key);

  @override
  _ProfileSettingsDialogState createState() => _ProfileSettingsDialogState();
}

class _ProfileSettingsDialogState extends State<ProfileSettingsDialog> {
  final _preferenciasUtil = new PreferenciasUtil();

  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();

  EditarDemografiaModel datosUsuario = new EditarDemografiaModel();

  GeneralProvider _generalProvider = new GeneralProvider();
  UsuarioProvider _usuarioProvider = new UsuarioProvider();

  List<DepartamentoModel> listDepartamento = [];
  List<MunicipiosModel> listMunicipios = [];

  bool _disponibleMunicipios = false;
  bool _actualizandoUsuario = false;

  @override
  void initState() {
    super.initState();
    _getDepartamentos();
  }

  _getDepartamentos() async {
    List<DepartamentoModel> listado = await _generalProvider.getDepartamentos();
    if (mounted)
      setState(() {
        listDepartamento = listado;
        listDepartamento.sort((a, b) => a.nombre!.compareTo(b.nombre!));
      });
  }

  _getMunicipios(int? idEstado) async {
    setState(() {
      _disponibleMunicipios = false;
    });
    List<MunicipiosModel> listado =
        await _generalProvider.getMunicipioPorIdEstado(idEstado);
    setState(() {
      listMunicipios = listado;
      listMunicipios.sort((a, b) => a.nombre!.compareTo(b.nombre!));
      _disponibleMunicipios = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.settings),
                    SizedBox(width: 10),
                    Text(
                      'Configuración de perfil',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(labelText: 'Nombre'),
                          initialValue: widget.user!.nombres,
                          // validator: (input) => input!.trim().length < 3
                          //     ? 'Not a valid full name'
                          //     : null,
                          onChanged: (input) => datosUsuario.nombre = input,
                          onSaved: (input) => datosUsuario.nombre = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(labelText: 'Apellido'),
                          initialValue: widget.user!.apellidos,
                          // validator: (input) => input!.trim().length < 3
                          //     ? 'Not a valid full name'
                          //     : null,
                          onSaved: (input) => datosUsuario.apellido = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.emailAddress,
                          decoration: getInputDecoration(
                              labelText: 'Dirección entregas'),
                          initialValue: widget.user!.direccion,
                          onChanged: (input) => datosUsuario.direccion = input,
                          onSaved: (input) => datosUsuario.direccion = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(
                              hintText: '123456', labelText: 'Telefono'),
                          initialValue: widget.user!.numeroTelefono,
                          onChanged: (input) =>
                              datosUsuario.telefono = int.parse(input),
                          onSaved: (input) =>
                              datosUsuario.telefono = int.parse(input!),
                        ),
                        // TODO :  Pendiente revisar el cambio de municipio y departamento
                        // FormField<DepartamentoModel>(
                        //   builder: (FormFieldState<DepartamentoModel> state) {
                        //     return DropdownButtonFormField<DepartamentoModel>(
                        //       decoration:
                        //           getInputDecoration(labelText: 'Departamento'),
                        //       hint: Text(widget.user!.estado!),

                        //       onChanged: (input) {
                        //         _getMunicipios(input?.id);
                        //       },
                        //       //onSaved: (input) => widget.user!.gender = input,
                        //       items:
                        //           listDepartamento.map((DepartamentoModel val) {
                        //         return DropdownMenuItem<DepartamentoModel>(
                        //           value: val,
                        //           child: new Text(
                        //             val.nombre!,
                        //           ),
                        //         );
                        //       }).toList(),
                        //     );
                        //   },
                        // ),
                        // _disponibleMunicipios
                        //     ? FormField<MunicipiosModel>(
                        //         builder:
                        //             (FormFieldState<MunicipiosModel> state) {
                        //           return DropdownButtonFormField<
                        //               MunicipiosModel>(
                        //             decoration: getInputDecoration(
                        //                 labelText: 'Municipio'),
                        //             // hint: Text(widget.user!.poblacion!),

                        //             onChanged: (input) {
                        //               // setState(() {
                        //               //   widget.user!.gender = input;
                        //               //   widget.onChanged!();
                        //               // });
                        //             },
                        //             //onSaved: (input) => widget.user!.gender = input,
                        //             items: listMunicipios
                        //                 .map((MunicipiosModel val) {
                        //               return DropdownMenuItem<MunicipiosModel>(
                        //                 value: val,
                        //                 child: new Text(
                        //                   val.nombre!,
                        //                 ),
                        //               );
                        //             }).toList(),
                        //           );
                        //         },
                        //       )
                        //     : SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        onPressed: _submit,
                        child: Text(
                          'Guardar',
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(height: 10),
                ],
              );
            });
      },
      child: Text(
        "Editar",
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  InputDecoration getInputDecoration({String? hintText, String? labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2!.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      labelStyle: Theme.of(context).textTheme.bodyText2!.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }

  void _submit() async {
    if (_profileSettingsFormKey.currentState!.validate()) {
      _profileSettingsFormKey.currentState!.save();

      datosUsuario.correo = widget.user!.email!;
      datosUsuario.idPoblacion = 0;
      datosUsuario.nroDocumento = 0;

      _usuarioProvider
          .modificarUsuario(datosUsuario, context)
          .then((value) async {
        RespuestaDatosModel? respuesta = value;
        if (respuesta?.codigo == 10) {
          final funcionNavegar = () async {
            await _preferenciasUtil.setPrefStr("nombres", datosUsuario.nombre!);
            await _preferenciasUtil.setPrefStr(
                "apellidos", datosUsuario.apellido!);
            await _preferenciasUtil.setPrefStr(
                "direccion", datosUsuario.direccion!);
            await _preferenciasUtil.setPrefStr(
                "telefono", datosUsuario.telefono.toString());
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
