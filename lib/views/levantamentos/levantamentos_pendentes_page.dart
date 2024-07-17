import 'package:bikesharemobile/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:bikesharemobile/data/provider/api.dart';
import 'package:bikesharemobile/widgets/pagina_em_manutencao.dart';
import 'package:bikesharemobile/widgets/actualizar_aplicacao_page.dart';
import 'package:bikesharemobile/views/levantamentos/widgets/pagamentos_pendentes_widget.dart';
import 'package:bikesharemobile/widgets/falha_conexao_internet_widget.dart';

class LevantamentosPendentesPage extends StatefulWidget {
  @override
  LevantamentosPendentesState createState() => LevantamentosPendentesState();
}

class LevantamentosPendentesState extends State<LevantamentosPendentesPage>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  var estadoApp = 1;

  _getEstado() async {
    var _estadoApp = await API().getEstado('pagamentos_pendentes_page');
    if (this.mounted) {
      setState(() {
        estadoApp = _estadoApp;
      });
    }
  }

  @override
  void initState() {
    _getEstado();
    _controller = new TabController(length: 1, vsync: this);
    super.initState();
  }

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
          child: (estadoApp == 0)
              ? ActualizarAppPage()
              : (estadoApp == 2)
                  ? PaginaEmManutencao()
                  : _body(),
        ),
      ),
    );
  }

  _body() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Card(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: const EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
              ),
              child: Row(
                children: [
                  Spacer(),
                  Spacer(),
                  IconButton(
                    icon: const Icon(Icons.print_sharp),
                    color: AppColors.blue,
                    iconSize: 40,
                    tooltip: 'Imprimir',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: <Widget>[
                  PagamentosPendentesWidget(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
