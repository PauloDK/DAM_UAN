import 'package:bikesharemobile/config/config.dart';
import 'package:bikesharemobile/controller/saldo/pagamento_controller.dart';
import 'package:bikesharemobile/widgets/RoundedColoredButton.dart';
import 'package:bikesharemobile/widgets/info.dart';
import 'package:flutter/material.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/Bike.dart';

class BikeDetails extends StatefulWidget {
  var bicicleta;
  BikeDetails({
    Key? key,
    required this.bicicleta,
  }) : super(key: key);
  @override
  _BikeDetailsState createState() =>
      _BikeDetailsState(this.bicicleta);
}

class _BikeDetailsState extends State<BikeDetails>
    with SingleTickerProviderStateMixin {
  final bicicleta;
   final PagamentoController c = Get.put(PagamentoController());
  NumberFormat formatter = NumberFormat('#,##0.00', 'ID');

  _BikeDetailsState(this.bicicleta);

  int? bicicletaId;

@override
  void initState() {
    bicicletaId = bicicleta['id'];
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          ColumnSuper(
            innerDistance: -20,
            children: [
              Container(
                  height: (MediaQuery.of(context).size.height * 1) / 3,
                  width: (MediaQuery.of(context).size.width),
                  decoration:
                      const BoxDecoration(color: AppColors.backgroungBeige),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 10),
                    child: Image.network(
                                    'http://127.0.0.1:8000/storage/${bicicleta['url']}', // Replace with your image path
                                  
                                  ),
                  )),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.backgroungBeige,
                ),
                child: Container(
                  height: (MediaQuery.of(context).size.height * 2) / 3,
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bicicleta['designacao'],
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: AppColors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                height: 2)),
                        const SizedBox(height: 10),
                        Text(bicicleta['tipologia']['designacao'],
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: AppColors.darkGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1.5)),
                        Container(
                          margin: EdgeInsets.only(right: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Informações do proprietário",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: const Color.fromARGB(255, 15, 232, 26),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      height: 3)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Info(label: "Nome", value: bicicleta['proprietario']['nome']),
                                  Info(label: "Telefone", value: bicicleta['proprietario']['telefone']),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Info(label: "Estação", value:bicicleta['doca']==null?'':bicicleta['doca']['estacao']['city']),
                                  Info(
                                      label: "Taxa",
                                      value: "${formatter.format(bicicleta['preco'])} \$/Dia"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RoundedColoredButton(
                                  width: 100,
                                  height: 33,
                                  text: "Voltar",
                                  textColor: Colors.white,
                                  fillColor: AppColors.blue,
                                  shadowBlurRadius: 0,
                                  onPressed: () {
                                    Navigator.of(context).pushNamed("/home");
                                  }),
                              RoundedColoredButton(
                                  width: 120,
                                  height: 33,
                                  text: "Levantar Agora",
                                  textColor: Colors.white,
                                  fillColor: const Color.fromARGB(255, 15, 232, 26),
                                  shadowBlurRadius: 0,
                                  onPressed: () {
                                  
                                        c.lolevantarBicicleta(bicicletaId, bicicleta['preco']);
                                  })
                            ])
                      ]),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}