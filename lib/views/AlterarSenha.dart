import 'package:bikesharemobile/config/colors.dart';
import 'package:bikesharemobile/models/User.dart';
import 'package:bikesharemobile/viewmodels/UserViewModel.dart';
import 'package:bikesharemobile/widgets/RoundedColoredButton.dart';
import 'package:bikesharemobile/widgets/side_drawer.dart';
import 'package:flutter/material.dart';
import '../global.dart' as global;

class AlterarSenhaPage extends StatelessWidget {
  AlterarSenhaPage({Key? key}) : super(key: key);

  TextEditingController passwordTextController = TextEditingController();
  TextEditingController passwordNovaTextController = TextEditingController();
  TextEditingController passwordVerificarTextController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

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
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer:SideDrawer(),
      appBar: AppBar(
        title: Text(
          'Alteração de Senha',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromARGB(255, 15, 232, 26),
      ),
      body: SingleChildScrollView(
        //color: AppColors.white,
        padding: const EdgeInsets.all(15),
        child: Container(
          // height: 300,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text('Alterar Senha',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: AppColors.blue,
                            height: 1)),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    style: TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock_outlined,
                        color: Colors.grey,
                      ),
                      hintText: "Senha Actual",
                      hintStyle: TextStyle(
                        color: Color(0xFF9b9b9b),
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    validator: (passwordValue) {
                      if (passwordValue!.isEmpty) {
                        return 'Por favor, informe a senha';
                      }
                      return null;
                    },
                    controller: passwordTextController,
                    onChanged: (password) {
                      //c.alterasenha["senha"] = password;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    style: TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock_outlined,
                        color: Colors.grey,
                      ),
                      hintText: "Nova Senha",
                      hintStyle: TextStyle(
                        color: Color(0xFF9b9b9b),
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    validator: (passwordValue) {
                      if (passwordValue!.isEmpty) {
                        return 'Por favor. informe a nova senha';
                      }
                      return null;
                    },
                    controller: passwordNovaTextController,
                    onChanged: (passwordNova) {
                      //c.alterasenha["nova_senha"] = passwordNova;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outlined,
                          color: Colors.grey,
                        ),
                        hintText: "Confirmar Nova Senha",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (passwordValue) {
                        if (passwordValue!.isEmpty) {
                          return 'Por favor, confirme a nova a senha';
                        } else if (passwordValue.length < 8) {
                          return 'A senha deve ter no mínimo 8 caracteres';
                        } else if (passwordNovaTextController.text !=
                            passwordValue) {
                          return 'Confirmação da nova senha diferente da \nnova senha.';
                        }
                        return null;
                      },
                      controller: passwordVerificarTextController,
                      onChanged: (passwordVerificar) async {
                        if (_formKey.currentState!.validate()) {
                          /* setState(() {
                        _isLoading = true;
                      });*/
                          //await c.alterarSenha();
                          /* setState(() {
                        _isLoading = false;
                      });*/
                        }
                      }),
                  SizedBox(height: 10.0),
                  RoundedColoredButton(
                      width: 350,
                      height: 50,
                      text: 'GRAVAR ALTERAÇÃO',
                      textColor: Colors.white,
                      fillColor: const Color.fromARGB(255, 15, 232, 26),
                      onPressed: () async {},
                      shadowBlurRadius: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
