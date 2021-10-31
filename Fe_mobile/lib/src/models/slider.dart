class Slider {
  String? image;
  String? button;
  String? description;

  Slider({this.image, this.button, this.description});
}

class SliderList {
  List<Slider>? _list;

  List<Slider>? get list => _list;

  SliderList() {
    _list = [
      new Slider(image: 'img/BannerPrimero.jpg', button: '', description: ''),
      new Slider(
          image: 'img/slider1.jpg',
          button: 'Explora',
          description: 'Se tu mismo y se libre de escoger tus gustos'),
      new Slider(
          image: 'img/slider2.jpg',
          button: 'Visita nuestra tienda',
          description: 'So many books, so little time.'),
    ];
  }
}
