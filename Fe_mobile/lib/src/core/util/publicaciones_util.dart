class PublicacionUtil {
  static const int PRODUCTO = 1;
  static const int SERVICIO = 2;

  static int parse(int value) {
    switch (value) {
      case PRODUCTO:
        return 1;
      case SERVICIO:
        return 2;
      default:
        return 0;
    }
  }
}
