// servicio con metodos estaticos para calculos nutricionales
class NutricionService {
  // calcula el indice de masa corporal a partir de peso (kg) y talla (cm)
  static double calcularIMC(double peso, double talla) {
    final tallaMetros = talla / 100;
    return peso / (tallaMetros * tallaMetros);
  }

  // calcula el requerimiento calorico estimado basado en el peso
  static double calcularRequerimientoCalorico(double peso) {
    return peso * 27.5;
  }

  // clasifica el imc en bajo peso, normal, sobrepeso u obesidad
  static String clasificarIMC(double imc) {
    if (imc < 18.5) return 'Bajo peso';
    if (imc < 25) return 'Normal';
    if (imc < 30) return 'Sobrepeso';
    return 'Obesidad';
  }
}
