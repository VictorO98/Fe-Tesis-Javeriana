class OnBoarding {
  String image;
  String description;

  OnBoarding({this.image, this.description});
}

class OnBoardingList {
  List<OnBoarding> _list;

  List<OnBoarding> get list => _list;

  OnBoardingList() {
    _list = [
      new OnBoarding(
          image: 'img/onboarding0.png',
          description: 'No llores porque se acabó, sonríe porque pasó.'),
      new OnBoarding(
          image: 'img/onboarding1.png',
          description: 'Se tu mismo, los demas ya están ocupados.'),
      new OnBoarding(
          image: 'img/onboarding2.png',
          description: 'Muchos libros, poco tiempo'),
      new OnBoarding(
          image: 'img/onboarding3.png',
          description: 'Una habitación sin libros es como un cuerpo sin alma.'),
    ];
  }
}
