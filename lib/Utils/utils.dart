
import 'package:intl/intl.dart';

class Utils {

  static String numberFormatter(double number){
    final formatter = NumberFormat("###,###,##0.00", "THB");
    String numberComma = formatter.format(number);
    return numberComma;
  }

}