import 'package:flutter/services.dart';

class DateTextFormatter extends TextInputFormatter {
  final String separator;

  DateTextFormatter(this.separator);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    if (text.length >= 2 && text[2] != separator) {
      text = text.substring(0, 2) + separator + text.substring(2);
    }
    if (text.length >= 5 && text[5] != separator) {
      text = text.substring(0, 5) + separator + text.substring(5);
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
