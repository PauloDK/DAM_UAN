import 'package:bikesharemobile/config/colors.dart';
import 'package:bikesharemobile/views/levantamentos/pagamentos_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:bikesharemobile/data/provider/api.dart';
import 'package:bikesharemobile/widgets/falha_conexao_internet_widget.dart';
import 'package:get/get.dart';

class TodosPagamentosWidget extends StatefulWidget {
  @override
  TodosPagamentosWidgetState createState() => TodosPagamentosWidgetState();
}

class TodosPagamentosWidgetState extends State<TodosPagamentosWidget> {
  GetStorage box = GetStorage();


  final FocusNode myFocusNode = FocusNode();


  var levantamentos;
  var total;
  var levantamentos1;
  int index = 0;
  bool _isLoading = true;
  NumberFormat formatter = NumberFormat('#,##0.00', 'ID');
  static const int numItems = 10;
  List<bool> selected = List<bool>.generate(numItems, (int index) => false);
  Future<void>? _launched;

  @override
  void initState() {
    _loadData();
    super.initState();
  }



  _loadData() async {
    try {
      var response = await API().getData(
          'meu-historico');
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
                  'Sem histórico...',
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
                      trailing: const Icon(Icons.info,size: 50,
                          color: AppColors.blue),
                      leading: Text('${index + 1}.',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black,
                          )),
                      title: Text(
                          '${levantamentos[index]['bicicleta']['designacao']}',
                          style: const TextStyle(
                              color: AppColors.blue, fontWeight: FontWeight.bold)),
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
                                    '${levantamentos[index]['bicicleta']['preco'] == null ? '' : formatter.format(levantamentos[index]['bicicleta']['preco'])} AOA'),
                            const TextSpan(
                                text: '\nQuilometragem: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            TextSpan(
                                text:
                                    '${levantamentos[index]['bicicleta']['quilometragem']} Km'),
                            const TextSpan(
                                text: '\nEstação: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            TextSpan(
                                text:
                                    '${levantamentos[index]['bicicleta']['doca'] == null ? '' : levantamentos[index]['bicicleta']['doca']['estacao']['city']}'),
                           const TextSpan(
                                text: '\nOperação: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                           
                              TextSpan(
                                children: <InlineSpan>[
                                  TextSpan(
                                      text:
                                          '${levantamentos[index]['operacao']}  '
                                              .toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold)),
                                  
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
