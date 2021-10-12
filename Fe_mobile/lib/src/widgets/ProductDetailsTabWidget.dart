import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/models/product.dart';
import 'package:Fe_mobile/src/widgets/FlashSalesCarouselWidget.dart';
import 'package:flutter/material.dart';

class ProductDetailsTabWidget extends StatefulWidget {
  ProductoServicioModel? product;
  ProductsList _productsList = new ProductsList();

  ProductDetailsTabWidget({this.product});

  @override
  ProductDetailsTabWidgetState createState() => ProductDetailsTabWidgetState();
}

class ProductDetailsTabWidgetState extends State<ProductDetailsTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              Icons.insert_drive_file_outlined,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              'Descripción',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(widget.product!.descripcion!),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              Icons.more_outlined,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              'Productos Relacionados',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        // FlashSalesCarouselWidget(
        //     heroTag: 'product_details_related_products',
        //     productsList: widget._productsList.flashSalesList),
      ],
    );
  }
}

class SelectColorWidget extends StatefulWidget {
  SelectColorWidget({
    Key? key,
  }) : super(key: key);

  @override
  _SelectColorWidgetState createState() => _SelectColorWidgetState();
}

class _SelectColorWidgetState extends State<SelectColorWidget> {
  List<Color> _colors = [
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.black45,
    Colors.orange,
  ];

  Color _selectedColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _colors.map((color) {
        return buildColor(color, _selectedColor);
      }).toList(),
    );
  }

  SizedBox buildColor(color, selectedColor) {
    return SizedBox(
      width: 38,
      height: 38,
      child: FilterChip(
        label: Text(''),
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        backgroundColor: color,
        selectedColor: color,
        selected: selectedColor == color,
        shape: StadiumBorder(),
        avatar: Text(''),
        onSelected: (bool value) {
          setState(() {
            this._selectedColor = color;
          });
        },
      ),
    );
  }
}

class SelectSizeWidget extends StatefulWidget {
  SelectSizeWidget({
    Key? key,
  }) : super(key: key);

  @override
  _SelectSizeWidgetState createState() => _SelectSizeWidgetState();
}

class _SelectSizeWidgetState extends State<SelectSizeWidget> {
  List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

  String _selectedSize = 'M';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _sizes.map((size) {
        return buildSize(size, _selectedSize);
      }).toList(),
    );
  }

  SizedBox buildSize(size, selectedSize) {
    return SizedBox(
//      width: 38,
      height: 38,
      child: RawChip(
        label: Text(size),
        labelStyle: TextStyle(color: Theme.of(context).hintColor),
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        backgroundColor: Theme.of(context).focusColor.withOpacity(0.05),
        selectedColor: Theme.of(context).focusColor.withOpacity(0.2),
        selected: selectedSize == size,
        shape: StadiumBorder(
            side: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.05))),
//        avatar: Icon(Icons.check_circle),
        onSelected: (bool value) {
          setState(() {
            this._selectedSize = size;
          });
        },
      ),
    );
  }
}
