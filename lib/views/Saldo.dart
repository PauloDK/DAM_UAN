import 'package:bikesharemobile/config/colors.dart';
import 'package:bikesharemobile/controller/saldo/saldo_controller.dart';
import 'package:bikesharemobile/views/Carregamento.dart';
import 'package:bikesharemobile/widgets/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SaldoPage extends StatefulWidget {
  SaldoPage({Key? key}) : super(key: key);

  @override
  _SaldoPageState createState() => _SaldoPageState();
}

class _SaldoPageState extends State<SaldoPage> {
  final SaldoController c = Get.put(SaldoController());
  NumberFormat formatter = NumberFormat('#,##0 00', 'ID');
  var index = 1;

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
    c.pegaCarregamentos();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: SideDrawer(),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Meu Saldo',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromARGB(255, 15, 232, 26),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.to(Carregamento());
                },
                icon: Icon(
                  Icons.add_rounded,
                  size: 30,
                ),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        //color: AppColors.white,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              width: screenSize.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color.fromARGB(255, 15, 232, 26),
                border: Border.all(
                    color: AppColors.blue,
                    width: 1.0,
                    style: BorderStyle.solid),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Saldo",
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: AppColors.darkGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${formatter.format(c.saldo)} AOA",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: AppColors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2))
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: const Text(
                'Meus Carregamentos',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: AppColors.blue,
                    height: 1),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            
            for (var carga in c.carregamentos) ...[
              Ink(
                color: index.isEven ? AppColors.yellow : Colors.transparent,
                child: ListTile(
                  leading: Text(
                    "${index++}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  title: Text(
                      "${formatter.format(carga['valorEntregue'])} AOA",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  subtitle: Text(
                    "${DateFormat("dd-MM-yyyy h:m:s").format(DateTime.parse(carga['created_at']))}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.print_rounded),
                    iconSize: 30,
                    color: Colors.blue,
                    onPressed: () {},
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        isScrollControlled: true,
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 0.7,
                            child: Column(
                              children: <Widget>[
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: '\nDetalhes do Carregamento\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text('   Referência',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )),
                                  subtitle: Text(
                                    "   ${carga['referencia']}",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                ListTile(
                                  title: Text('   Número de Operação Bancária',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )),
                                  subtitle: Text(
                                    "   ${carga['num_operacao_bancaria']}",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                 ListTile(
                                  title: Text('   Banco',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )),
                                  subtitle: Text(
                                    "   ${carga['banco']['designacao']}",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                
                                ListTile(
                                  title: Text('   Forma de Pagamento',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )),
                                  subtitle: Text(
                                    "   ${carga['forma_pagamento']['designacao']}",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                     ListTile(
                                  title: Text('   Montante',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )),
                                  subtitle: Text(
                                    "   ${formatter.format(carga['valorEntregue'])} AOA",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                     ListTile(
                                  title: Text('   Estado',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )),
                                  subtitle: Text(
                                    "   ${carga['estado']['designacao']}",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                ListTile(
                                  title: Text('   Data de Envio',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )),
                                  subtitle: Text(
                                    "   ${DateFormat("dd-MM-yyyy h:m:s").format(DateTime.parse(carga['created_at']))}",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),

                              ],
                            ),
                          );
                        });
                  },
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
