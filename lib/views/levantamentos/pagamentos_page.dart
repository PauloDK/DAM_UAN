import 'package:bikesharemobile/widgets/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bikesharemobile/config/colors.dart';
import 'package:bikesharemobile/views/levantamentos/todos_levantamentos_page.dart';
import 'package:bikesharemobile/views/levantamentos/levantamentos_pendentes_page.dart';


class LevantamentoPage extends StatelessWidget {
  LevantamentoPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: SideDrawer(),
        appBar: AppBar(
            title: const Text('Levantamentos'),
            bottom: const TabBar(
              indicatorColor: Colors.white,
              isScrollable: true,
              tabs: [
                Tab(text: 'Entregas Pendentes'),
                Tab(text: 'Histórico(Levantamento & Entregas)'),
              ],
            ),
            backgroundColor: AppColors.yellow),
        body: SafeArea(
          bottom: false,
          child: TabBarView(
            children: [
              LevantamentosPendentesPage(),
              TodosLevantamentosPage(),

            ],
          ),
        ),
    ),
    );
  }
}
