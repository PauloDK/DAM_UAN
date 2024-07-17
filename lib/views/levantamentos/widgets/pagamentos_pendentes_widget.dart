import 'dart:io';
import 'dart:convert';
import 'package:bikesharemobile/config/config.dart';
import 'package:bikesharemobile/views/levantamentos/pagamentos_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:bikesharemobile/data/provider/api.dart';
import 'package:bikesharemobile/widgets/falha_conexao_internet_widget.dart';

class PagamentosPendentesWidget extends StatefulWidget {
  @override
  PagamentosPendentesWidgetState createState() =>
      PagamentosPendentesWidgetState();
}

class PagamentosPendentesWidgetState extends State<PagamentosPendentesWidget> {
  GetStorage box = GetStorage();
  var levantamentos;
  var total;
  var levantamentos1;
  var condominioId;
  bool _isLoading = true;
  NumberFormat formatter = NumberFormat('#,##0.00', 'ID');
  Future<void>? _launched;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    try {
      var response = await API().getData('entrega-pendente');
      if (response.statusCode == 200) {
        if (this.mounted) {
          setState(() {
            levantamentos1 = json.decode(response.body);
            levantamentos = levantamentos1["bicicletas"];
            _isLoading = false;
          });
        }
      }
    } on SocketException catch (_) {
    } on HttpException catch (_) {
    } on FormatException catch (_) {
    } on NoSuchMethodError catch (_) {}
  }

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
    return OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder: (BuildContext context,
          ConnectivityResult connectivity, Widget child) {
        if (connectivity == ConnectivityResult.none) {
          return FalhaNaConexaoComInternet();
        }
        return child;
      },
      child: _body(),
    );
  }

  _body() {
    return _isLoading
        ? CircularProgressIndicator()
        : (levantamentos.length == 0 || levantamentos == null)
            ? const Center(
                child: Text(
                  'Sem levantamnto pendente...',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                ),
                itemCount: levantamentos.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      trailing: IconButton(
                        icon: const Icon(Icons.send, size: 50),
                        color: AppColors.blue,
                        iconSize: 40,
                        tooltip: 'Entregar Bicicleta',
                        onPressed: () {
                          Get.dialog(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Material(
                                        child: Column(
                                          children: [
                                            const Icon(Icons.info_rounded,
                                                size: 50,
                                                color: AppColors.yellow),
                                            const SizedBox(height: 10),
                                            const Text("Atenção",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(height: 15),
                                            Text(
                                              "Pretende entregar esta bicicleta?",
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 20),
                                            //Buttons
                                            Row(
                                              children: [
                                                ElevatedButton(
                                                  child: const Text(
                                                    "Não",
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    minimumSize:
                                                        const Size(0, 45),
                                                    primary: AppColors.grey,
                                                    onPrimary:
                                                        const Color(0xFFFFFFFF),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                ),
                                                Spacer(),
                                                ElevatedButton(
                                                  child: const Text(
                                                    "Sim",
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    minimumSize:
                                                        const Size(0, 45),
                                                    primary: Colors.green,
                                                    onPrimary:
                                                        const Color(0xFFFFFFFF),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    _isLoading = true;
                                                    var response = await API()
                                                        .getData(
                                                            'entregar-bicicleta/${levantamentos[index]['id']}');
                                                    if (response.statusCode ==
                                                        200) {
                                                           Get.back();
                                                      if (this.mounted) {
                                                        var mensagem =
                                                            json.decode(
                                                                response.body);
Navigator.of(context).pop();
                                                        Get.snackbar('Sucesso!',
                                                            '$mensagem',
                                                            backgroundColor:
                                                                Colors.green,
                                                            colorText:
                                                                Colors.white,
                                                            duration: Duration(
                                                                seconds: 3,
                                                                milliseconds:
                                                                    500));
                                                        setState(() {
                                                          _isLoading = false;
                                                         
                                                        });
                                                      }
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      leading: Text('${index + 1}.',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black,
                          )),
                      title: Text('${levantamentos[index]['designacao']}',
                          style: const TextStyle(
                              color: AppColors.blue,
                              fontWeight: FontWeight.bold)),
                      subtitle: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: '',
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Taxa: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            TextSpan(
                                text:
                                    '${levantamentos[index]['preco'] == null ? '' : formatter.format(levantamentos[index]['preco'])}'),
                            const TextSpan(
                                text: '\nQuilometragem: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            TextSpan(
                                text:
                                    '${levantamentos[index]['quilometragem']}'),
                            const TextSpan(
                                text: '\nEstação: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            TextSpan(
                                text:
                                    '${levantamentos[index]['doca']['estacao']['city'] == null ? '' : levantamentos[index]['doca']['estacao']['city']}'),
                            const TextSpan(
                                text: '\nProprietário: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            TextSpan(
                                text:
                                    '${levantamentos[index]['proprietario']['nome'] ?? ''}'),
                            const TextSpan(
                                text: '\nEstado: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            if (levantamentos[index]['estado_bicicleta_id'] ==
                                1)
                              TextSpan(
                                children: <InlineSpan>[
                                  TextSpan(
                                      text:
                                          '${levantamentos[index]['estado']['designacao']}  '
                                              .toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold)),
                                  WidgetSpan(
                                      child: Icon(
                                    Icons.info,
                                    color: Colors.orange,
                                    size: 20,
                                  )),
                                ],
                              ),
                            if (levantamentos[index]['estado_bicicleta_id'] ==
                                2)
                              TextSpan(
                                children: <InlineSpan>[
                                  TextSpan(
                                      text:
                                          '${levantamentos[index]['estado']['designacao']}  '
                                              .toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                  WidgetSpan(
                                      child: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 20,
                                  )),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }
}
