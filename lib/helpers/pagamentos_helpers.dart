//import 'dart:ui';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
//import 'package:path/path.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
//import 'package:ata/app/network_utils/api.dart';
//Simport 'package:ata/app/ui/android/pagamento/pagamento_page.dart';

class PagamentosHelper {
  NumberFormat numberFormatter = new NumberFormat("#,###.##", 'pt_BR');
  GetStorage box = GetStorage();
  //final _url = API().getUrl();

  var token;
  var comprovativo = File('').obs;
  final nomeFicheiro = 'Escolha um ';
  List? data;
  List? servicos;
  List? bancos;
  List? formaPagamento;
  var tipoTaxa = '';
  var proximoMes = '';
  var ano = 1;
  var anoStaff = 1;
  var contribuicao = 0.0;
  var tipoTaxa2 = '';
  var tipoTaxa3 = '';
  var proximoMes2 = '';
  var proximoMes3 = '';
  var contribuicao2 = 0.0;
  var contribuicao3 = 0.0;
  var taxistaId = 1;
  var staffId = 1;
  var mesQtd = 1;
  var ano2 = 1;
  var ano3 = 1;
  var inss = 1;
  var inss2 = 1;
  var tipoTaxaId = 1;
  var tipoTaxaId2 = 1;
  var tipoTaxaId3 = 1;
  var pagamento = {}.obs;

  String? progress;
  DIO.Dio dio = new DIO.Dio();
  var userId;
  var staffId2;

  /*_auxiliarEliminar(context, idPagamento) async {
    var response =
        await API().postData(null, 'pagamento-eliminar/$idPagamento');
    var msg = jsonDecode(response.body);
    if (response.statusCode == 200) {
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  WidgetSpan(
                      child: Icon(Icons.check_circle,
                          size: 50, color: Colors.green)),
                  TextSpan(
                      text: '\nSucesso',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                ],
              ),
            ),
            content: Text("${msg['msg']}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 14)),
            actions: [
              MaterialButton(
                textColor: Colors.red,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PagamentoPage(6)));
                },
                child:
                    const Text('Certo', style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      );
    } else {
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  WidgetSpan(
                      child: Icon(Icons.close_outlined,
                          size: 40, color: Colors.red)),
                  TextSpan(
                      text: '\nErro!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                ],
              ),
            ),
            content: Text("${msg['msg']}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 14)),
            actions: [
              MaterialButton(
                textColor: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                },
                child:
                    const Text('Certo', style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      );
    }
  }

  eliminarPagamento(BuildContext context, String idPagamento) async {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                WidgetSpan(
                    child: Icon(Icons.delete, size: 50, color: Colors.red)),
                TextSpan(
                    text: '\nEliminação de Pagamento',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
              ],
            ),
          ),
          content: Text("Eliminar este pagamento?",
              textAlign: TextAlign.justify,
              style: const TextStyle(color: Colors.black, fontSize: 16)),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Não', style: const TextStyle(color: Colors.blue)),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () {
                _auxiliarEliminar(context, idPagamento);
              },
              child:
                  const Text('Sim', style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  motivoRejeicaoPagamento(BuildContext context, String codigoPagamento) async {
    await API().getData('fatura-by-reference/$codigoPagamento').then((req) {
      var response = json.decode(req.body);
      var fatura = response["fatura"];
      var extenso = response["extenso"];
      var itens = response["itens"];
      fatura["ValorAPagar"] =
          fatura["ValorAPagar"] != null ? fatura["ValorAPagar"] : 0;
      fatura["ValorEntregue"] =
          fatura["ValorEntregue"] != null ? fatura["ValorEntregue"] : 0;
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  WidgetSpan(
                    child:
                        Image.asset('assets/images/logo_novo.png', scale: 0.1),
                  ),
                  const TextSpan(
                      text: 'Fatura Nº: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 14)),
                ],
              ),
            ),
            content: ListView.builder(
              itemCount: itens.length,
              itemBuilder: (context, index) {
                return RichText(
                  text: TextSpan(
                    style: TextStyle(),
                    children: [
                      TextSpan(
                        text: '${index + 1} - Serviço: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14),
                      ),
                      TextSpan(
                          text: '${itens[index]["servico"]}',
                          style: TextStyle(color: Colors.black, fontSize: 14)),
                    ],
                  ),
                );
              },
            ),
            actions: [
              Center(child: Text('\n($extenso)')),
              MaterialButton(
                textColor: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Fechar'),
              )
            ],
          );
        },
      );
    }).catchError((e) {});
  }*/
}
