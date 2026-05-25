// extension para capitalizar la primera letra de un string
extension StringExtension on String {
  // convierte la primera letra a mayuscula y el resto a minuscula
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
