import 'package:Fe_mobile/src/dominio/models/categoria_model.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/dominio/providers/contenido_provider.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class FiltroPublicacionesWidget extends StatefulWidget {
  List<ProductoServicioModel>? products;
  VoidCallback? onChanged;

  FiltroPublicacionesWidget({Key? key, this.products, this.onChanged})
      : super(key: key);

  @override
  _FiltroPublicacionesWidgetState createState() =>
      _FiltroPublicacionesWidgetState();
}

class _FiltroPublicacionesWidgetState extends State<FiltroPublicacionesWidget> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();

  //List<CategoriaModel>? categorias = [];
  List<String>? categorias = ['Tecnología', 'Entrenimiento', 'Salud'];

  ContenidoProvider _contenidoProvider = new ContenidoProvider();

  String? categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    initialConfiguration();
  }

  initialConfiguration() async {
    var lista = await _contenidoProvider.getAllCategorias();
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
                    Icon(Icons.search),
                    SizedBox(width: 10),
                    Text(
                      'Filtros',
                      style: Theme.of(context).textTheme.body2,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return DropdownButtonFormField<String>(
                              decoration: getInputDecoration(
                                  hintText: 'Categorías', labelText: ''),
                              hint: Text("Categorías"),
                              value: categoriaSeleccionada,
                              onChanged: (input) {
                                // setState(() {
                                //   widget.user!.gender = input;
                                //   widget.onChanged!();
                                // });
                              },
                              //onSaved: (input) => widget.user!.gender = input,
                              items: categorias!.map((String val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: new Text(
                                    val,
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(
                              hintText: '12000', labelText: 'Precio inferior'),
                          initialValue: '',

                          //onSaved: (input) => widget.user!.email = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(
                              hintText: '12000', labelText: 'Precio Superior'),
                          initialValue: '',

                          //onSaved: (input) => widget.user!.email = input,
                        ),
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
                      MaterialButton(
                        onPressed: _submit,
                        child: Text(
                          'Filtrar',
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
      child: Icon(Icons.search, color: Theme.of(context).hintColor),
    );
  }

  InputDecoration getInputDecoration({String? hintText, String? labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.body1!.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      hasFloatingPlaceholder: true,
      labelStyle: Theme.of(context).textTheme.body1!.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_profileSettingsFormKey.currentState!.validate()) {
      _profileSettingsFormKey.currentState!.save();
      var prod = widget.products;
      Navigator.pop(context);
    }
  }
}
