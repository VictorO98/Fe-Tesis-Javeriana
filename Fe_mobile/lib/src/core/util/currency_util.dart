import 'package:money2/money2.dart';

class CurrencyUtil {
  static String convertFormatMoney(String moneyFormat, int value) {
    Currency createCurrency;
    value >= 1000
        ? createCurrency = Currency.create(moneyFormat, 0,
            invertSeparators: true, pattern: 'S0.000')
        : createCurrency = Currency.create(moneyFormat, 0,
            invertSeparators: true, pattern: 'S000');
    final valueWithFormat = Money.fromInt(value, createCurrency);
    return valueWithFormat.toString();
  }
}
