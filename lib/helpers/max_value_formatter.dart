import 'package:flutter/services.dart';

class MaxValueInputFormatter extends TextInputFormatter {
  final double maxValue;

  MaxValueInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue; // Allow empty value
    }

    try {
      final enteredValue = double.parse(newValue.text);
      if (enteredValue >= maxValue) {
        // Return the old value if the new value exceeds the max limit
        return oldValue;
      }
    } catch (e) {
      // If the input is invalid, just return the old value
      return oldValue;
    }

    return newValue; // Allow the new value if it's within the limit
  }
}
