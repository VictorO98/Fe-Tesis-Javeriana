import 'package:Fe_mobile/src/dominio/models/categoria_model.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/dominio/providers/contenido_provider.dart';
import 'package:Fe_mobile/src/dominio/widgets/resultado_busqueda_grid_widget.dart';
import 'package:Fe_mobile/src/dominio/widgets/resultado_busqueda_widget.dart';
import 'package:Fe_mobile/src/dominio/widgets/vacio_busqueda_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BusquedaUsuarioWidget extends StatefulWidget {
  List<ProductoServicioModel>? publicaciones;
  String? tipoPublicacion;

  @override
  _BusquedaUsuarioWidgetState createState() => _BusquedaUsuarioWidgetState();

  BusquedaUsuarioWidget({Key? key, this.publicaciones, this.tipoPublicacion})
      : super(key: key);
}

class _BusquedaUsuarioWidgetState extends State<BusquedaUsuarioWidget> {
  String layout = 'list';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Offstage(
            offstage: widget.publicaciones!.isEmpty,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: ButtonTheme(
                  padding: EdgeInsets.all(0),
                  minWidth: 50.0,
                  height: 25.0,
                  child: FiltroPublicacionesWidget(
                    products: widget.publicaciones,
                    onChanged: () {
                      setState(() {});
                    },
                  ),
                ),
                title: Text(
                  'Filtros',
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: Theme.of(context).textTheme.headline4,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          this.layout = 'list';
                        });
                      },
                      icon: Icon(
                        Icons.format_list_bulleted,
                        color: this.layout == 'list'
                            ? Theme.of(context).accentColor
                            : Theme.of(context).focusColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          this.layout = 'grid';
                        });
                      },
                      icon: Icon(
                        Icons.apps,
                        color: this.layout == 'grid'
                            ? Theme.of(context).accentColor
                            : Theme.of(context).focusColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Offstage(
            offstage: this.layout != 'list' || widget.publicaciones!.isEmpty,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: widget.publicaciones!.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return ResultadoBusquedaWidget(
                  heroTag: 'orders_list',
                  product: widget.publicaciones!.elementAt(index),
                  onDismissed: () {
                    setState(() {
                      widget.publicaciones!.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
          Offstage(
            offstage: this.layout != 'grid' || widget.publicaciones!.isEmpty,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: new StaggeredGridView.countBuilder(
                primary: false,
                shrinkWrap: true,
                crossAxisCount: 4,
                itemCount: widget.publicaciones!.length,
                itemBuilder: (BuildContext context, int index) {
                  ProductoServicioModel publicacion =
                      widget.publicaciones!.elementAt(index);
                  return ResultadoBusquedaGridWidget(
                    product: publicacion,
                    heroTag: 'orders_grid',
                  );
                },
//                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 15.0,
              ),
            ),
          ),
          Offstage(
            offstage: widget.publicaciones!.isNotEmpty,
            child: VacioBusquedaWidget(),
          )
        ],
      ),
    );
  }
}

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

  List<CategoriaModel>? _categorias = [];
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
                      style: Theme.of(context).textTheme.bodyText1,
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

  void _submit() {
    if (_profileSettingsFormKey.currentState!.validate()) {
      _profileSettingsFormKey.currentState!.save();
      var prod = widget.products;
      Navigator.pop(context);
    }
  }
}
