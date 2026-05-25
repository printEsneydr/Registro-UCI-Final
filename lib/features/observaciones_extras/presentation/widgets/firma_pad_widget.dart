// widget que muestra un dialogo para capturar una firma manuscrita
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class FirmaPadWidget extends StatefulWidget {
  // base64 de la firma existente para mostrar, callback al guardar
  final String initialBase64;
  final ValueChanged<String> onSave;

  const FirmaPadWidget({
    super.key,
    this.initialBase64 = '',
    required this.onSave,
  });

  @override
  State<FirmaPadWidget> createState() => _FirmaPadWidgetState();
}

class _FirmaPadWidgetState extends State<FirmaPadWidget> {
  late SignatureController _controller;

  // inicializa el controlador de firma
  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  // libera el controlador de firma
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // convierte la firma a png y la retorna en base64
  Future<void> _save() async {
    if (_controller.isNotEmpty) {
      final Uint8List? pngBytes = await _controller.toPngBytes();
      if (pngBytes != null) {
        widget.onSave(base64Encode(pngBytes));
      }
    } else {
      widget.onSave('');
    }
  }

  // construye el dialogo con el area de firma y botones de accion
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.draw, color: Colors.blue),
                const SizedBox(width: 8),
                const Text('Firma', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (widget.initialBase64.isNotEmpty)
                  SizedBox(
                    width: 80,
                    height: 30,
                    child: Image.memory(base64Decode(widget.initialBase64), fit: BoxFit.contain),
                  ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _controller.clear(),
                  tooltip: 'Limpiar',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: 400,
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Signature(
                controller: _controller,
                height: 180,
                width: 400,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _save();
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
