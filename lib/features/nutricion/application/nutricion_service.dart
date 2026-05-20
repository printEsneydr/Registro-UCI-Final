class NutricionService {
  static double calcularIMC(double peso, double talla) {
    final tallaMetros = talla / 100;
    return peso / (tallaMetros * tallaMetros);
  }

  static double calcularRequerimientoCalorico(double peso) {
    return peso * 27.5;
  }

  static String clasificarIMC(double imc) {
    if (imc < 18.5) return 'Bajo peso';
    if (imc < 25) return 'Normal';
    if (imc < 30) return 'Sobrepeso';
    return 'Obesidad';
  }
}
