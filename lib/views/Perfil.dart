import 'package:bikesharemobile/config/colors.dart';
import 'package:bikesharemobile/controller/perfil/perfil_controller.dart';
import 'package:bikesharemobile/models/User.dart';
import 'package:bikesharemobile/viewmodels/UserViewModel.dart';
import 'package:bikesharemobile/widgets/RoundedColoredButton.dart';
import 'package:bikesharemobile/widgets/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../global.dart' as global;

class PerfilPage extends StatelessWidget {
  PerfilPage({Key? key}) : super(key: key);

  var emailController = TextEditingController();
  var fullNameController = TextEditingController();
  var pwdController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  final PerfilController c = Get.put(PerfilController());
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text("Carregando...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Meu Perfil',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromARGB(255, 15, 232, 26),
      ),
      body: Container(
        color: AppColors.white,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Center(
                child: ClipOval(
              child: Image.asset(
                'assets/images/user.png',
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            )),
            SizedBox(
              height: 10,
            ),
            Center(
              child:  Text(
                '${c.nomeCompleto}',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: AppColors.blue,
                    height: 1),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.yellow),
              title: const Text('Nome completo'),
              subtitle:  Text('${c.nomeCompleto}'),
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(Icons.person, color: AppColors.yellow),
              title: const Text('Nome de Utilizador'),
              subtitle:  Text('${c.username}'),
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(Icons.email, color: AppColors.yellow),
              title: const Text('E-mail'),
              subtitle:  Text('${c.email}'),
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(Icons.phone_android, color: AppColors.yellow),
              title: const Text('Telefone'),
              subtitle:  Text('${c.telefone}'),
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(Icons.gps_fixed, color: AppColors.yellow),
              title: const Text('Endereço'),
              subtitle: Text('${c.endereco??'informação indisponível'}'),
              onTap: () => {},
            ),
            SizedBox(
              height: 20,
            ),
            RoundedColoredButton(
                width: 350,
                height: 50,
                text: ' EDITAR PERFIL',
                textColor: Colors.white,
                fillColor: const Color.fromARGB(255, 15, 232, 26),
                onPressed: () async {
                  showLoaderDialog(context);
                },
                shadowBlurRadius: 0),
          ],
        ),
      ),
    );
  }
}
