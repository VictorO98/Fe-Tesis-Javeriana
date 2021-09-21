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
      new Notification('img/home4.webp', 'Tus guantes esta siendo empacados',
          '33min ago', false),
      new Notification('img/home5.webp',
          'Tu frediora ha sido enviada, esperala pronto', '32min ago', true),
      new Notification('img/home6.webp', 'Tú matera esta pendiente de pago',
          '34min ago', true),
    ];
  }

  List<Notification>? get notifications => _notifications;
}
