import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bikesharemobile/widgets/estado_widget.dart';

class ActualizarAppPage extends StatelessWidget {
  download() {
    try {
      launch("market://details?id=com.bikesharemobile");
    } on PlatformException catch (_) {
      launch(
          "https://play.google.com/store/apps/details?id=com.bikesharemobile");
    } finally {
      launch(
          "https://play.google.com/store/apps/details?id=com.bikesharemobile");
    }
  }

  @override
  Widget build(BuildContext context) {
    return EstadoWidget(
      estado: 1,
      widget: _body,
    );
  }

  _body() {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        primary: false,
        body: Center(
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.download_rounded,
              color: Colors.white,
              size: 28.0,
            ),
            //color: Colors.green,
            label: const Text(
              '\nBaixar versão Actualizada\n do BikeShared Mobile na Play Store\n',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => {download()},
          ),
        ),
      ),
    );
  }
}
