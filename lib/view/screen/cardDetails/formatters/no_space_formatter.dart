import 'package:flutter/services.dart';

class NoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final hasEmptySpace = newValue.text.trim() == oldValue.text;
    if (hasEmptySpace) {
      return TextEditingValue(
        text: newValue.text.trim(),
        selection: oldValue.selection,
      );
    }
    return newValue;
  }
}
