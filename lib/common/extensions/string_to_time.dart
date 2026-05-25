import 'package:flutter/material.dart';

// extension para convertir un string "HH:mm" a TimeOfDay
extension ToDayTime on String {
  // convierte "HH:mm" a TimeOfDay
  TimeOfDay toDayTime() {
    final splitted = split(':');
    final hours = splitted[0];
    final minutes = splitted[1];

    return TimeOfDay(
      hour: int.parse(hours),
      minute: int.parse(minutes),
    );
  }
}
