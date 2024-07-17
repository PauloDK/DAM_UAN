import 'package:bikesharemobile/config/colors.dart';
import 'package:bikesharemobile/controller/auth/login_controller.dart';
import 'package:bikesharemobile/widgets/RoundedColoredButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController c = Get.put(LoginController());


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
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Criar Uma Nova Conta',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 30,
            height: 2,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color.fromARGB(255, 15, 232, 26),
       
      ),
      body: Container(
        color: AppColors.white,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: const Text(
                'Realize o Cadastro?',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: AppColors.blue,
                    height: 1),
              ),
            ),
             Container(
              child:  Form(
                    key: _formKey,
                    child: Column(children: [
                          SizedBox(
              height: 50,
              child: TextField(
                controller: c.nameTextController,
                decoration: InputDecoration(
                    hintText: 'Nome Completo',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff9BAEBC),
                    ),
                    filled: false,
                    contentPadding:
                        const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        width: 1,
                        color: AppColors.blue,
                      ),
                    )),
              ),
            ),
              SizedBox(
              height: 20),
            TextField(
              controller: c.emailTextController,
              decoration: InputDecoration(
                  hintText: 'E-mail',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff9BAEBC),
                  ),
                  filled: false,
                  contentPadding:
                      const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      width: 1.0,
                      color: AppColors.blue,
                    ),
                  )),
            ),
            SizedBox(
              height: 20),
            TextField(
              controller: c.passwordTextController,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Senha',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff9BAEBC),
                  ),
                  filled: false,
                  contentPadding:
                      const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      width: 1.0,
                      color: AppColors.blue,
                    ),
                  )),
            ),
             SizedBox(
              height: 20),
            TextField(
              controller: c.bairroTextController,
              decoration: InputDecoration(
                  hintText: 'Endereço',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff9BAEBC),
                  ),
                  filled: false,
                  contentPadding:
                      const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      width: 1.0,
                      color: AppColors.blue,
                    ),
                  )),
            ),
             SizedBox(
              height: 20),
            TextField(
              controller: c.phoneTextController,
              decoration: InputDecoration(
                  hintText: 'Telefone',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff9BAEBC),
                  ),
                  filled: false,
                  contentPadding:
                      const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      width: 1.0,
                      color: AppColors.blue,
                    ),
                  )),
            ),
            SizedBox(
              height: 60),
            RoundedColoredButton(
                width: 350,
                height: 50,
                text: 'ENVIAR',
                textColor: Colors.white,
                fillColor: Color.fromARGB(255, 15, 232, 26),
                onPressed: () async {
                  //showLoaderDialog(context);
               
                              if (_formKey.currentState!.validate()) {
                                if (c.isLoading.isFalse) {
                                  await c.register(
                                       c.nameTextController.text,
                                      c.emailTextController.text,
                                      c.passwordTextController.text,
                                      c.phoneTextController.text,  
                                      c.bairroTextController.text);
                                }
                              }
                            
                },
                shadowBlurRadius: 0),
           
                    ],))),
         SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Image.asset("assets/images/illustration.png"),
            ),
          ],
        ),
      ),
    );
  }
}
