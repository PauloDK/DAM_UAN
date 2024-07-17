import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bikesharemobile/data/provider/api.dart';
import 'package:bikesharemobile/routes/app_pages.dart';

/*
  Author: Mande Paulo
  Description: Usada pra autenticação/autorização  e registo do utilizador
*/

class LoginController extends GetxController {
  GetStorage box = GetStorage();

  final LocalAuthentication _localAuthentication = LocalAuthentication();
  List? generos;
  List? provincias;
  //List? municipios;
  var municipios = [].obs;
  List? estadosCivis;
  var province;
  var isLoadingMunicipio = false.obs;
  var selecionarMunicipioState = true.obs;

  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController passwordConfirmTextController = TextEditingController();

  TextEditingController biTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController phone2TextController = TextEditingController();
  TextEditingController ruaTextController = TextEditingController();
  TextEditingController casaTextController = TextEditingController();
  TextEditingController bairroTextController = TextEditingController();
  TextEditingController nascimentoTextController = TextEditingController();
  TextEditingController provinciaTextController = TextEditingController();
  TextEditingController generoTextController = TextEditingController();
  TextEditingController civilTextController = TextEditingController();
  TextEditingController muniTextController = TextEditingController();

  var talaoBanco = File('').obs;

  Rx<bool> checkBiometric = false.obs;
  Rx<bool> hasFingerPrintSupport = false.obs;

  final isLoading = false.obs;
  var globalData;
  // String _message = "Not Authorized";

  API _apiService = Get.find<API>();

  @override
  void onInit() {
    //checkAppVersion();
    //checkBiometricStatus();
    dadosAdicionais();
    super.onInit();
  }

  //Método para cadastrar utilizador
  register(name, email, password, phone, bairro) async {
    isLoading.value = true;
    var data = {
      'name': name,
      'email': email,
      'password': password,
      'device_name': 'mobile',
      "nome_completo": name,
      "bairro": bairro,
      "telefone": phone,
    };
    var dados;
    try {
      var response = await _apiService.postData(data, 'user-create');
      if (response.statusCode == 200) {
        var res = await _apiService.postData(data, 'login-create');
        dados = json.decode(res.body);

        var userdata = dados['userdata'];
        var token = dados['token'];
        final storage = new FlutterSecureStorage();
        await storage.write(key: 'credentials', value: json.encode(data));

        box.erase();

        box.write("user_id", userdata["id"]);
        box.write("nome", userdata["name"]);
        box.write("email", userdata["email"]);
        box.write("role", userdata["tipo_user_id"]);
        box.write("foto", userdata["foto"]);
        box.write("saldo", userdata["saldo"]);
        //Dados Pessoais
        box.write("nome_completo", userdata["pessoa"]["nome"]);
        // box.write("nascimento", userdata["pessoa"]["data_nascimento"]);
        box.write("telefone", userdata["pessoa"]["numero_telefone"]);
        /*box.write("telefone", userdata["pessoa"]["telefone2"]);
        box.write("rua", userdata["pessoa"]["localidade"]["rua"]);
        box.write("bairro", userdata["pessoa"]["localidade"]["bairro"]);
        box.write("casa", userdata["pessoa"]["localidade"]["numero_residencia"]);
        box.write("numero_bi", userdata["pessoa"]["numero_bi"]);
        box.write("provincia", userdata["pessoa"]["localidade"]["provincia"]["designacao"]);
        box.write("municipio", userdata["pessoa"]["localidade"]["municipio"]["designacao"]);
        box.write("genero", userdata["pessoa"]["genero"]["designacao"]);
        box.write("estado_civil", userdata["pessoa"]["estado_civil"]["designacao"]);
        box.write("cliente_id", userdata["pessoa"]["cliente"]["id"]);*/

        _saveUserData(userdata, token);

        //var canLogin = await this.carregarDadosHome();
        Future.delayed(Duration(seconds: 2));
        Get.snackbar('Sucesso', 'Bem-vindo(a) ao Diaristas Angola',
            backgroundColor: Colors.green.withOpacity(0.5),
            colorText: Colors.white);

        Get.offNamedUntil(Routes.HOME, (route) => false);
      } else if (response.statusCode == 201) {
        Get.snackbar('Erro', 'Credenciais Inválidas, tente novamente!',
            backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        Get.snackbar('Erro', json.decode(response.body),
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } on SocketException catch (_) {
      Get.snackbar('Erro', 'Verifique a sua conexão com a internet!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } on HttpException catch (_) {
      Get.snackbar('Erro', 'Houve um erro interno, tente novamente!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } on FormatException catch (_) {
      Get.snackbar('Erro', 'Houve um erro interno, tente novamente!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } on NoSuchMethodError catch (_) {
      Get.snackbar('Erro', 'Houve um erro interno, tente novamente!',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    isLoading.value = false;
  }

  //  Método usado para efectuar login no sistema
  login(email, password) async {
    isLoading.value = true;
    var data = {
      'email': email,
      'password': password,
      'device_name': 'mobile',
    };
    var dados;

    try {
      var response = await _apiService.postData(data, 'login-create');

      if (response.statusCode == 200) {
        dados = json.decode(response.body);
        var userdata = dados['userdata'];
        var token = dados['token'];
        final storage = new FlutterSecureStorage();
        await storage.write(key: 'credentials', value: json.encode(data));
        Get.snackbar('Sucesso!', 'Bem-vindo(a) ao BikeShared',
            backgroundColor: Colors.white.withOpacity(0.5));
        box.erase();

        box.write("user_id", userdata["id"]);
        box.write("nome", userdata["name"]);
        box.write("email", userdata["email"]);
        box.write("role", userdata["tipo_user_id"]);
        box.write("foto", userdata["foto"]);
        box.write("saldo", userdata["saldo"]);
        //Dados Pessoais
        box.write("nome", userdata["pessoa"]["nome"]);
        // box.write("nascimento", userdata["pessoa"]["data_nascimento"]);
        box.write("telefone", userdata["pessoa"]["numero_telefone"]);
        /*box.write("telefone", userdata["pessoa"]["telefone2"]);
        box.write("rua", userdata["pessoa"]["localidade"]["rua"]);
        box.write("bairro", userdata["pessoa"]["localidade"]["bairro"]);
        box.write("casa", userdata["pessoa"]["localidade"]["numero_residencia"]);
        box.write("numero_bi", userdata["pessoa"]["numero_bi"]);
        box.write("provincia", userdata["pessoa"]["localidade"]["provincia"]["designacao"]);
        box.write("municipio", userdata["pessoa"]["localidade"]["municipio"]["designacao"]);
        box.write("genero", userdata["pessoa"]["genero"]["designacao"]);
        box.write("estado_civil", userdata["pessoa"]["estado_civil"]["designacao"]);
        box.write("cliente_id", userdata["pessoa"]["cliente"]["id"]);*/

        _saveUserData(userdata, token);

        Get.offNamedUntil(Routes.HOME, (route) => false);
      } else {
        Get.snackbar('Erro', json.decode(response.body),
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } on SocketException catch (_) {
      Get.snackbar('Erro', 'Verifique a sua conexão com a internet!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } on HttpException catch (_) {
      Get.snackbar('Erro', 'Houve um erro interno, tente novamente!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } on FormatException catch (_) {
      Get.snackbar('Erro', 'Houve um erro interno, tente novamente!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } on NoSuchMethodError catch (_) {
      Get.snackbar('Erro', 'Houve um erro interno, tente novamente!',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    isLoading.value = false;
    emailTextController.text = "";
    passwordTextController.text = "";
  }

  // Carregar dados da página inicial
  carregarDadosHome() async {
    var response = await _apiService.getData('servicos-list-todos');

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      var globalData = {
        'servico': data.containsKey("servico") ? data["servico"] : null,
      };
      box.write('globalData', json.encode(globalData));
      return true;
    } else if (response.statusCode == 400) {
      Get.snackbar('Erro!', json.decode(response.body),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    return false;
  }

  // Método para salvar dados do utilizador no box (Local Storage)
  _saveUserData(userdata, token) async {
    box.write("token", token);
    box.write("user_id", userdata["user_id"]);
  }

  dadosAdicionais() async {
    isLoading.toggle();
    try {
      var response = await API().getData('dados-apoio');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        provincias = data["provincias"];
        //municipios = data["municipios"];
        generos = data["generos"];
        estadosCivis = data["estados_civis"];
      }
    } on SocketException catch (_) {
    } on HttpException catch (_) {
    } on FormatException catch (_) {
    } on NoSuchMethodError catch (_) {}
    isLoading.toggle();
  }

  buscaMunicipio() async {
    isLoadingMunicipio.value = false;

    if (province == null) {
      municipios = [].obs;
      selecionarMunicipioState.value = true;
    } else {
      selecionarMunicipioState.value = false;
      var response =
          await API().getData('buscar-municipios?provincia_id=$province');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        municipios.assignAll(data["municipios"]);
        Future.delayed(Duration(seconds: 2));
      }
    }
    isLoadingMunicipio.value = false;
  }
}
