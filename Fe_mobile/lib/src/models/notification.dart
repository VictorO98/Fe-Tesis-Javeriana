class Notification {
  String image;
  String title;
  String time;
  bool read;

  Notification(this.image, this.title, this.time, this.read);
}

class NotificationList {
  List<Notification>? _notifications;

  NotificationList() {
    this._notifications = [
      new Notification('img/hola1.jpeg',
          'Tu vela aromatica esta siendo empacada', '33min ago', false),
      new Notification(
          'img/hola2.jpeg',
          'Tu estatua de colección ha sido enviada, esperala pronto',
          '32min ago',
          true),
      new Notification('img/hola3.jpeg',
          'Tú cojin para meditar esta pendiente de pago', '34min ago', true),
    ];
  }

  List<Notification>? get notifications => _notifications;
}
