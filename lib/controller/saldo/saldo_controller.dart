import 'dart:io';
import 'dart:convert';
import 'package:bikesharemobile/views/home.dart';
import 'package:bikesharemobile/views/saldo.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:bikesharemobile/helpers/ficheiro_helper.dart';
import 'package:bikesharemobile/data/provider/api.dart';
import 'package:get_storage/get_storage.dart';

class SaldoController extends GetxController {
  //TextEditing Controller for Form Fields
  TextEditingController dataBancoTextController = TextEditingController();
  TextEditingController numeroOperacaoTextController = TextEditingController();
  var formaPagamentoTextController = "".obs;
  var contaMovimentadaTextController = "".obs;
  TextEditingController valorDepositadoTextController = TextEditingController();

  API _apiService = Get.find<API>();

  DIO.Dio dio = new DIO.Dio();
  final nomeFicheiro = 'Escolha um '.obs;
  final isLoadingPagamento = false.obs;
  var talaoBanco = File('').obs;
  final isLoading = true.obs;
  var pagamento = {}.obs;
  var estadoApp = 1.obs;
  int? saldo;
  List? bancos;
  List? formasPagamentos;
  var carregamentos = [].obs;

  GetStorage box = GetStorage();
  final _url = API().getUrl();
  // var token;
  List? data;

  var isLoadingData = false.obs;
  var isLoadingBancos = false.obs;

  @override
  void onInit() {
    _getId();
    getToken();
    super.onInit();
  }

  @override
  void onClose() {
    limparDados();
    super.onClose();
  }

  getToken() async {
    var token = box.read('token');
    dio = DIO.Dio()..options.headers['authorization'] = 'Bearer $token';
  }

  carregarDados() async {
    isLoading.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      limparCampos();
      await pegaBancos();
      await pegaFormasPagamentos();
      Future.delayed(Duration(seconds: 2));
    });
    isLoading.value = false;
  }

  limparCampos() {
    valorDepositadoTextController.text = "";
    numeroOperacaoTextController.text = "";
    talaoBanco.value = File('');
    dataBancoTextController.text = "";
  }

  _getId() async {
    saldo = box.read("saldo");
  }

  pegaBancos() async {
    isLoading.toggle();
    try {
      _getId();
      var response = await API().getData('buscar-bancos');
      if (response.statusCode == 200) {
        bancos = json.decode(response.body);
      }
    } on SocketException catch (_) {
    } on HttpException catch (_) {
    } on FormatException catch (_) {
    } on NoSuchMethodError catch (_) {}
    isLoading.toggle();
  }

  pegaCarregamentos() async {
    isLoading.toggle();
    try {
      _getId();
      var response = await API().getData('carregamentos');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
          carregamentos.assignAll(data["carregamentos"]);
        Future.delayed(Duration(seconds: 2));
      }
    } on SocketException catch (_) {
    } on HttpException catch (_) {
    } on FormatException catch (_) {
    } on NoSuchMethodError catch (_) {}
    isLoading.toggle();
  }

  pegaFormasPagamentos() async {
    isLoading.toggle();
    try {
      var response = await API().getData('buscar-formas-pagamentos');
      if (response.statusCode == 200) {
        formasPagamentos = json.decode(response.body);
      }
    } on SocketException catch (_) {
    } on HttpException catch (_) {
    } on FormatException catch (_) {
    } on NoSuchMethodError catch (_) {}
    isLoading.toggle();
  }

  
  uploadAnexoDialog() async {
    Get.defaultDialog(
      title: 'Selecione a fonte',
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () async {
                  final file = await FicheiroHelper().capturaCamara();
                  if (file != null) {
                    talaoBanco.value = file;
                  }
                  Get.back();
                },
                icon: Icon(
                  Icons.camera_alt,
                  size: 34,
                ),
              ),
              Text('Câmara')
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () async {
                  final file = await FicheiroHelper().selectFromGaleria();
                  if (file != null) {
                    talaoBanco.value = file;
                  }
                  Get.back();
                },
                icon: Icon(
                  Icons.photo_library,
                  size: 34,
                  color: Colors.blue,
                ),
              ),
              Text('Galeria')
            ],
          ),
        ],
      ),
    );
  }

  


  void limparDados() {
    pagamento.clear();
  }

  carregarSaldo() async {
    isLoadingPagamento.toggle();
    try {
      String uploadurl = '$_url/api/carregar-saldo';

      DIO.FormData? formdata = DIO.FormData.fromMap({
        "comprovativo": await DIO.MultipartFile.fromFile(
            talaoBanco.value.path,
            filename: basename(talaoBanco.value.path),
          ),
          "valorEntregue": valorDepositadoTextController.text,
          "banco_id": contaMovimentadaTextController.value,
          "forma_pagamento_id": formaPagamentoTextController.value,
          "data_pagamento": dataBancoTextController.text,
          "num_operacao_bancaria": numeroOperacaoTextController.text
      });
      var response = await dio.post(
        uploadurl,
        data: formdata,
      );
print(response);
      var mensagem = response.data;
      if (response.statusCode == 200) {
        pagamento.value = {};
        limparCampos();
        Get.to(() => Home());
        Get.snackbar('Sucesso!', '$mensagem',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3, milliseconds: 500));
      } else if (response.statusCode == 201) {
        Get.defaultDialog(
            title: "Atenção!", middleText: '$mensagem', onConfirm: () {});
      } else if (response.statusCode == 500) {
        Get.snackbar("Erro", "Falha de comunicação");
      } else if (response.statusCode == 422) {
        Get.defaultDialog(
            title: "Atenção!", middleText: '$mensagem', onConfirm: () {});
      } else {
        Get.defaultDialog(
            title: "Atenção!", middleText: '$mensagem', onConfirm: () {});
      }
    } catch (e) {
      //print(e);
    } finally {}
    isLoadingPagamento.toggle();
  }

  void validar() async {
    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
    if (pagamento['forma_pagamento_id'] == null) {
      Get.snackbar(
          'Atenção', 'Por favor, preencha o campo: Forma de Pagamento');
    } else if (pagamento['forma_pagamento_id'] == null) {
      Get.snackbar('Atenção', 'Por favor, preencha o campo: Banco');
    } else if (pagamento['data_banco'] == null) {
      Get.snackbar('Atenção', 'Por favor, preencha o campo: Data do  Banco');
    } else if (!validCharacters.hasMatch(pagamento['n_operacao_bancaria'])) {
      Get.snackbar('Atenção',
          'O Nº de Operação Bancária deve conter apenas caracteres alfanuméricos');
    } else if (pagamento['n_operacao_bancaria'] == null) {
      Get.snackbar(
          'Atenção', 'Por favor, preencha o campo: Nº de Operação Bancária');
    } else if (num.tryParse(pagamento['valor_depositado'])! <
        pagamento["valor_a_pagar"]) {
      Get.snackbar('Atenção',
          'O valor depositado não deve ser menor que o valor a pagar');
    } else if (pagamento['valor_depositado'] == null) {
      Get.snackbar('Atenção', 'Por favor, preencha o campo: Valor Depositado');
    } else if (talaoBanco.isBlank!) {
      Get.snackbar('Atenção', 'Por favor, carregue o talão do banco');
    } else {
      carregarSaldo();
    }
  }


}
