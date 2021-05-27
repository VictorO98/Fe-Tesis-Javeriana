class InduccionModelList {
  String image;
  String description;

  InduccionModelList({this.image, this.description});
}

class OnBoardingList {
  List<InduccionModelList> _list;

  List<InduccionModelList> get list => _list;

  OnBoardingList() {
    _list = [
      new InduccionModelList(
          image: 'img/onboarding0.png',
          description: 'No llores porque se acabó, sonríe porque pasó.'),
      new InduccionModelList(
          image: 'img/onboarding1.png',
          description: 'Se tu mismo, los demas ya están ocupados.'),
      new InduccionModelList(
          image: 'img/onboarding2.png',
          description: 'Muchos libros, poco tiempo'),
      new InduccionModelList(
          image: 'img/onboarding3.png',
          description: 'Una habitación sin libros es como un cuerpo sin alma.'),
    ];
  }
}
