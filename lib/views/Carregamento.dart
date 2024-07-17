import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:bikesharemobile/controller/saldo/saldo_controller.dart';
import 'package:bikesharemobile/widgets/falha_conexao_internet_widget.dart';
import 'package:bikesharemobile/config/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';



class Carregamento extends StatefulWidget {
  @override
  _CarregamentoState createState() => _CarregamentoState();
}

class _CarregamentoState extends State<Carregamento> {
  final SaldoController c =
      Get.put(SaldoController());
  final FocusNode myFocusNode = FocusNode();
  NumberFormat numberFormatter = new NumberFormat("#,###.##", 'pt_BR');
  DateTime? _selectedDate;
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _myselection3;
  String? _myselection4;

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
    c.carregarDados();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder: (BuildContext context,
          ConnectivityResult connectivity, Widget child) {
        if (connectivity == ConnectivityResult.none) {
          return Container(child: FalhaNaConexaoComInternet());
        }
        return child;
      },
      child: Scaffold(
        key: _globalKey,
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Carregamento de Saldo"),
          backgroundColor: const Color.fromARGB(255, 15, 232, 26),
        ),
        body: Obx(() => c.isLoading.isTrue
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CircularProgressIndicator(),
              )
            : _body(context)),
      ),
    );
  }

  _body(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[                               
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(1),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 10.0,
                          left: 15.0,
                          bottom: 4.0,
                          top: 5.0,
                        ),
                        child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  const Icon(
                                    Icons.money,
                                    color: Colors.grey,
                                    size: 25.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        hint: const Text('Forma de Pagamento'),
                                        //underline: SizedBox(),
                                        items: c.formasPagamentos?.map((item) {
                                          return  DropdownMenuItem(
                                            child:  Text(
                                                '${item["designacao"]}'),
                                            value: item["id"].toString(),
                                            onTap: null,
                                          );
                                        }).toList(),
                                        onChanged: (String? newVal) {
                                          setState(() {
                                            _myselection3 = newVal;
                                            c.formaPagamentoTextController
                                                .value = newVal.toString();
                                          });
                                        },
                                        value: _myselection3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (c.formaPagamentoTextController.value
                                      .toString() !=
                                  'POR REFERÊNCIA') ...[
                                Row(
                                  children: [
                                   const Icon(
                                      Icons.account_balance,
                                      color: Colors.grey,
                                      size: 25.0,
                                    ),
                                    Obx(() => c.isLoadingBancos.isTrue
                                        ? Container(
                                            height: 20,
                                            width: 20,
                                            margin: EdgeInsets.only(left: 10.0),
                                            child: CircularProgressIndicator(
                                              backgroundColor:
                                                  Color(0xFF0A3CAC),
                                              color: Colors.red,
                                              strokeWidth: 3.0,
                                            ),
                                          )
                                        : Expanded(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.white),
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: DropdownButton(
                                                isExpanded: true,
                                                hint: const Text('Banco'),
                                                //underline: SizedBox(),
                                                items: c.bancos
                                                    ?.map((item) {
                                                  return DropdownMenuItem(
                                                    child: new Text(
                                                        '${item["designacao"]}'),
                                                    value:
                                                        item["id"].toString(),
                                                    onTap: null,
                                                  );
                                                }).toList(),
                                                onChanged: (String? newVal) {
                                                  setState(() {
                                                    _myselection4 = newVal;
                                                    c.contaMovimentadaTextController
                                                            .value =
                                                        newVal.toString();
                                                  });
                                                },
                                                value: _myselection4,
                                              ),
                                            ),
                                          )),
                                  ],
                                ),
                              const  SizedBox(
                                  height: 5.0,
                                ),
                                Center(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      icon: const Icon(Icons.date_range),
                                      hintText: 'Data do Banco',
                                      labelText: 'Data do Banco',
                                    ),
                                    focusNode: AlwaysDisabledFocusNode(),
                                    controller: c.dataBancoTextController,
                                    validator: (String? value) {
                                      if (value!.isEmpty)
                                        return 'Campo Obrigatório';
                                      return null;
                                    },
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^[a-zA-Z0-9]+$'))
                                  ],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    icon: const Icon(Icons.account_balance),
                                    hintText: 'Nº de Operação Bancária',
                                    labelText: 'Nº de Operação Bancária',
                                  ),
                                  onChanged: (numeroOperacaoBancaria) {
                                    c.numeroOperacaoTextController.text =
                                        numeroOperacaoBancaria;
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Campo obrigatório';
                                    }
                                    return null;
                                  },
                                  controller: c.numeroOperacaoTextController,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                              
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  //enabled: false,
                                  decoration: const InputDecoration(
                                    icon: const Icon(Icons.attach_money),
                                    hintText: '0,00 ',
                                    labelText: 'Valor Depositado \$',
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                                  /*inputFormatters: [
                                    LengthLimitingTextInputFormatter(15),
                                    ThousandsFormatter(
                                        allowFraction: true,
                                        formatter: NumberFormat.currency(
                                          locale: "pt_PT",
                                          decimalDigits: 2, /*symbol: "kz"*/
                                        )),
                                  ],*/
                                  onChanged: (valorDepositado) {
                                  c.valorDepositadoTextController.text =
                                        valorDepositado;
                                  },
                                  onSaved: (input) => num.tryParse(input!),
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Campo obrigatório';
                                    }
                                    if (num.parse(value) <= 0) {
                                      return 'Insira um valor';
                                    }

                                    return null;
                                  },
                                  controller: c.valorDepositadoTextController,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.yellow),
                                      ),
                                      onPressed: () {
                                        c.uploadAnexoDialog();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.file_present_rounded,
                                            color: Colors.white,
                                          ),
                                          Text('Comprovativo'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5.0),
                                    Expanded(
                                      child: Obx(() => Text(
                                            c.talaoBanco.value.path == ""
                                                ? 'Anexe o comprovativo...'
                                                : basename(
                                                    c.talaoBanco.value.path),
                                          )),
                                    )
                                  ],
                                ),
                             
                                const Text(
                                  '\nAnexo (*Obrigatório) | Formatos permitidos: PNG, PDF, JPG | Tamanho máx. ficheiro: 2MB\n',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              SizedBox(height: 30.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      child:  Text(
                                          c.isLoadingPagamento.isTrue
                                              ? 'Carregando...'
                                              : 'Carregar',
                                          style: TextStyle(fontSize: 20)),
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: const Color.fromARGB(255, 15, 232, 26),
                                        onSurface: Colors.grey,
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!
                                              .validate()) {
                                            c.carregarSaldo();
                                          }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

 
  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        locale: const Locale("pt", "PT"),
        context: context,
        initialDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.white,
                surface: Colors.blueGrey,
                onSurface: Colors.black54,
              ),
              dialogBackgroundColor: const Color.fromARGB(255, 15, 232, 26),
            ),
            child: child!,
          );
        });
    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      c.dataBancoTextController
        ..text = DateFormat('yyyy-MM-dd').format(_selectedDate!)
        ..selection = TextSelection.fromPosition(
          TextPosition(
            offset: c.dataBancoTextController.text.length,
            affinity: TextAffinity.upstream,
          ),
        );
      if (this.mounted) {
        setState(() {
          c.pagamento["data_pagamento"] = _selectedDate.toString();
        });
      }
    }
  }

  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
    );
    if (!result.isBlank!) {
      File file = File(result!.files.single.path!);
      c.talaoBanco.value = file;
    }
  }
}


class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
