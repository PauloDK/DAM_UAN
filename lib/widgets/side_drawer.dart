import 'package:bikesharemobile/config/config.dart';
import 'package:bikesharemobile/controller/home/home_controller.dart';
import 'package:bikesharemobile/data/provider/api.dart';
import 'package:bikesharemobile/routes/app_pages.dart';
import 'package:bikesharemobile/views/levantamentos/pagamentos_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideDrawer extends StatelessWidget {
final HomeController c = Get.put(HomeController());

  TextEditingController passwordTextController = TextEditingController();
  TextEditingController passwordNovaTextController = TextEditingController();
  TextEditingController passwordVerificarTextController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              '${c.username}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
            accountEmail: Text('${c.email}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white)),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/user.png',
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            decoration: BoxDecoration(color: AppColors.yellow),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: AppColors.yellow),
            title: const Text('Painel Principal'),
            onTap: () => {Navigator.of(context).pushNamed("/home")},
          ),
          ListTile(
            leading: Icon(Icons.attach_money_outlined, color: AppColors.yellow),
            title: const Text('Meu Saldo'),
            onTap: () => {Navigator.of(context).pushNamed("/saldo")},
          ),
          ListTile(
            leading: Icon(Icons.bike_scooter, color: AppColors.yellow),
            title: const Text('Bicicletas Levantadas'),
            onTap: () => {Get.to(LevantamentoPage())},
          ),
            ListTile(
            leading: Icon(Icons.location_searching, color: AppColors.yellow),
            title: const Text('Mapa de Estações'),
            onTap: () => { Navigator.of(context).pushNamed("/mapa")},
          ),
          ListTile(
            leading: Icon(Icons.person, color: AppColors.yellow),
            title: const Text('Perfil'),
            onTap: () => {
              Navigator.of(context).pushNamed("/perfil"),
            },
          ),
          ListTile(
            leading: Icon(Icons.key, color: AppColors.yellow),
            title: const Text('Alterar Senha'),
            onTap: () => {
              Navigator.of(context).pushNamed("/senha"),
            },
          ),
          ListTile(
            leading: Icon(Icons.security, color: AppColors.yellow),
            title: const Text('Políticas de Privacidade'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.help, color: AppColors.yellow),
            title: const Text('Ajuda'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.settings_power, color: AppColors.yellow),
            title: const Text('Terminar Sessão'),
            onTap: () async {
                    await API().logout();
                    Get.offNamedUntil(Routes.INITIAL, (route) => false);
                  }
          ),
        ],
      ),
    );
  }
}
