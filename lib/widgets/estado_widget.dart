import 'package:flutter/material.dart';
import 'falha_conexao_internet_widget.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:bikesharemobile/widgets/pagina_em_manutencao.dart';
import 'package:bikesharemobile/widgets/actualizar_aplicacao_page.dart';

class EstadoWidget extends StatelessWidget {
  final estado;
  final widget;
  EstadoWidget({this.estado, this.widget});

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder: (BuildContext context,
          ConnectivityResult connectivity, Widget child) {
        if (connectivity == ConnectivityResult.none) {
          return Scaffold(body: FalhaNaConexaoComInternet());
        }
        return child;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: (estado == 0)
              ? ActualizarAppPage()
              : (estado == 2)
                  ? PaginaEmManutencao()
                  : widget,
        ),
      ),
    );
  }
}
