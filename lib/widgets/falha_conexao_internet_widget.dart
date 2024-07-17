import 'package:flutter/material.dart';

class FalhaNaConexaoComInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(text: '', children: [
            const WidgetSpan(
              child: const Icon(
                Icons.signal_wifi_off_outlined,
                size: 100,
                color: Colors.blue,
              ),
            ),
            const TextSpan(
              text: '\nInternet Indisponível...\nVerifique a Conexão do Seu Dispositivo à Internet',
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
