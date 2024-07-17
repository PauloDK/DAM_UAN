import 'package:bikesharemobile/config/colors.dart';
//import 'package:bikesharemobile/viewmodels/UserViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/RoundedColoredButton.dart';
import 'package:get/get.dart';
import 'package:bikesharemobile/controller/auth/login_controller.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 90,
                    width: 90,
                    child: Image.asset('assets/images/Vector.png'),
                  ),
                  const Text(
                    'Bike - Shared 2023',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: c.emailTextController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: 'Informe seu e-mail',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
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
              TextField(
                controller: c.passwordTextController,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Informe sua senha',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (value) {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        side: MaterialStateBorderSide.resolveWith(
                          (states) => const BorderSide(
                              width: 1.0, color: AppColors.blue),
                        ),
                      ),
                      const Text(
                        'Lembrar-me',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff9BAEBC),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Esqueceu a sua senha ?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff9BAEBC),
                    ),
                  ),
                ],
              ),
              RoundedColoredButton(
                  width: 350,
                  height: 50,
                  text: 'ENTRAR',
                  textColor: Colors.white,
                  fillColor: Color.fromARGB(255, 15, 232, 26),
                  onPressed: () async {
                    //showLoaderDialog(context);
                    if (_formKey.currentState!.validate()) {
                      if (c.isLoading.isFalse) {
                        await c.login(c.emailTextController.text,
                            c.passwordTextController.text);
                      }
                    }
                  },
                  shadowBlurRadius: 0),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 1,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'ou',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 1,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
           
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não tem uma conta ?  ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        {Navigator.of(context).pushNamed("/signUp"),},
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.only(right: 15, left: 15),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Criar uma conta Agora',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 15, 232, 26),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
             
            ],
          ),
        ),
      ),
      
    );
  }
}
