import 'package:bikesharemobile/views/BikeCode.dart';
import 'package:bikesharemobile/views/Carregamento.dart';
import 'package:bikesharemobile/views/Payment.dart';
import 'package:bikesharemobile/views/SignIn.dart';
import 'package:bikesharemobile/views/SignUp.dart';
import 'package:bikesharemobile/views/SmsAuth.dart';
import 'package:bikesharemobile/views/alterarSenha.dart';
import 'package:bikesharemobile/views/home.dart';
import 'package:bikesharemobile/views/saldo.dart';
import 'package:bikesharemobile/views/Estacoes.dart';
import 'package:bikesharemobile/views/Perfil.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:bikesharemobile/bindings/login_binding.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bikesharemobile/routes/app_pages.dart';
import 'package:get/get.dart';

/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/home": (_) => Home(),
        "/details": (_) => BikeDetails(),
        "/payment": (_) => Payment(),
        "/code": (_) => BikeCode(),
        "/map": (_) => Map(),
        "/signUp": (_) => SignUpPage(),
        "/sms": (_) => SmsAuth(),
        "/saldo": (_) => SaldoPage(),
        "/senha": (_) => AlterarSenhaPage(),
        "/perfil": (_) => PerfilPage()
      },
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}*/

void main() async {
  await GetStorage.init();
  runApp(GetMaterialApp(  
    routes: {
        "/home": (_) => Home(),
        "/payment": (_) => Payment(),
        "/code": (_) => BikeCode(),
        "/signUp": (_) => SignUpPage(),
        "/sms": (_) => SmsAuth(),
        "/saldo": (_) => SaldoPage(),
        "/senha": (_) => AlterarSenhaPage(),
        "/perfil": (_) => PerfilPage(),
        "/mapa": (_) => Estacoes(),
        "/carregamento": (_) => Carregamento()
      },   
      getPages: AppPages.pages,
      initialBinding: LoginBinding(),
      home: SignInPage(),
      localizationsDelegates: [
            GlobalMaterialLocalizations.delegate
          ],
          supportedLocales: [
            const Locale('pt')
          ],
  ));
}

