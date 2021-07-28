import 'dart:math';

import 'package:Fe_mobile/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class Review {
  String id = UniqueKey().toString();
  User user;
  String review;
  double rate;
  DateTime dateTime =
      DateTime.now().subtract(Duration(days: Random().nextInt(20)));

  Review(this.user, this.review, this.rate);

  getDateTime() {
    return DateFormat('yyyy-MM-dd HH:mm').format(this.dateTime);
  }
}

class ReviewsList {
  List<Review>? _reviewsList;

  List<Review>? get reviewsList => _reviewsList;

  ReviewsList() {
    this._reviewsList = [
      new Review(
          new User.basic('Maria alvarez', 'img/user0.jpg', UserState.available),
          'Excelente producto me ha ayudado a verme más bonita',
          4.7),
      new Review(
          new User.basic('Arreglos de joyas a domicilio', 'img/user2.jpg',
              UserState.available),
          'Fue un excelente regalo para mi esposa',
          4.5),
      new Review(
          new User.basic(
              'Eduardo Ezequiel', 'img/user2.jpg', UserState.available),
          'Muy buena calidad',
          4.9),
      new Review(
          new User.basic(
              'Jorge T. Ospina', 'img/user0.jpg', UserState.available),
          'Me gusto mucho el acabado que tenía cada uno',
          5.0),
      new Review(
          new User.basic(
              'Laura C. Benavidez', 'img/user2.jpg', UserState.available),
          'Muy buenos pero se pierde el brillo después de un tiempo',
          4.1)
    ];
  }
}
