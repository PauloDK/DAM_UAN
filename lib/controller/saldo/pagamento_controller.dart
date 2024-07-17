import 'dart:io';
import 'dart:convert';
import 'package:bikesharemobile/views/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bikesharemobile/data/provider/api.dart';

/*
  Author: Mande Paulo
  Description: Usada pra levantamento de bicicleta*/

class PagamentoController extends GetxController {
  GetStorage box = GetStorage();

  final isLoading = false.obs;

  API _apiService = Get.find<API>();

  @override
  void onInit() {
    super.onInit();
  }

  //Método para efectuar levantamento de bicicleta na doca/estação
  lolevantarBicicleta(bici, preco) async {
    isLoading.value = true;

    var mensagem;

    try {
      var response = await _apiService
          .getData('levantar-bicicleta?bici=$bici&preco=$preco');

      if (response.statusCode == 200) {
        mensagem = json.decode(response.body);
          var saldo = await _apiService
          .getData('consultar-saldo');
          box.write('saldo', saldo);
        Get.snackbar('Sucesso!', mensagem,
            backgroundColor: Colors.green, duration: Duration(seconds: 5));
        Get.to(Home());
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
}
