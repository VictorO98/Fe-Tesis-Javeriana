class InduccionModelList {
  String? image;
  String? description;

  InduccionModelList({this.image, this.description});
}

class OnBoardingList {
  List<InduccionModelList>? _list;

  List<InduccionModelList>? get list => _list;

  OnBoardingList() {
    _list = [
      new InduccionModelList(
          image: 'img/logo_buya.png',
          description: 'Anímate a vender y ganar dinero.'),
      new InduccionModelList(
          image: 'img/logo_buya.png',
          description: 'Paga como más te convenga.'),
      new InduccionModelList(
          image: 'img/logo_buya.png',
          description:
              'Encuentra todo lo que tu necesitas en tu tienda online'),
      // new InduccionModelList(
      //     image: 'img/logo_buya.png',
      //     description: 'Una habitación sin libros es como un cuerpo sin alma.'),
    ];
  }
}
