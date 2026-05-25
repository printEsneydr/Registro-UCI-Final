import 'package:flutter/material.dart';

// muestra un dialogo para seleccionar una hora
Future<TimeOfDay?> pickTime(
  BuildContext context,
  TimeOfDay initialTime,
  String message,
) async {
  TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: initialTime,
    initialEntryMode: TimePickerEntryMode.dial,
    hourLabelText: "HORA",
    minuteLabelText: "MINUTO",
    helpText: message,
  );
  return pickedTime;
}
