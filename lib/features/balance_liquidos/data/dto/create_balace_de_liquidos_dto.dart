import "dart:collection";

// dto para crear un balance de liquidos, extiende MapView para ser usado como mapa
class CreateBalanceDeLiquidosDto extends MapView<String, dynamic> {
  final int hora;
  final int orden;

  CreateBalanceDeLiquidosDto({
    required this.hora,
    required this.orden,
  }) : super({
          'hora': hora,
          'orden': orden,
        });
}
