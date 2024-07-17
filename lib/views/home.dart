import 'package:bikesharemobile/config/config.dart';
import 'package:bikesharemobile/controller/home/home_controller.dart';
import 'package:bikesharemobile/viewmodels/BikeViewModel.dart';
import 'package:bikesharemobile/views/BikeDetails.dart';
import 'package:bikesharemobile/widgets/RoundedColoredButton.dart';
import 'package:bikesharemobile/widgets/side_drawer.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';
import 'package:bikesharemobile/data/provider/api.dart';
import 'dart:io';
import 'dart:convert';

class Home extends StatefulWidget {
  static String routeName = '/home-screen';
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> images = [
    'assets/images/mountain.png',
    'assets/images/city.png',
    'assets/images/road.png',
    'assets/images/hybrid.png',
    'assets/images/electric.png',
    'assets/images/bycicle.png',
    'assets/images/mountain.png',
    'assets/images/city.png',
    'assets/images/road.png',
    'assets/images/hybrid.png'
  ];
  WeatherFactory wf = new WeatherFactory("af1120536d27c1029173735a6ab0bdbd");
  final dateToday = DateFormat.yMMMd().format(DateTime.now());

  final HomeController c = Get.put(HomeController());
  NumberFormat formatter = NumberFormat('#,##0.00', 'ID');
  dynamic bicicletas = [].obs;
  dynamic estacoes = [].obs;

  final _url = API().getUrl();
  bool _isLoading = true;
  bool _isLoadingEstacoes = true;

  @override
  void initState() {
    getBicicletas();
    getEstacoes();
    
    super.initState();
  }

  getBicicletas() async {
    try {
      var res = await API().getData('listar-bikes');

      if (res.statusCode == 200) {
        if (this.mounted) {
          setState(() {
            Map<String, dynamic> response = json.decode(res.body);
            bicicletas = response['trancadas'];
            Future.delayed(Duration(seconds: 2));
            _isLoading = false;
          });
        }
      }
    } on SocketException catch (_) {
    } on HttpException catch (_) {
    } on FormatException catch (_) {}
  }

   getEstacoes() async {
    try {
      var res = await API().getData('estacoes-docas');

      if (res.statusCode == 200) {
        if (this.mounted) {
          setState(() {
            Map<String, dynamic> response = json.decode(res.body);
            estacoes = response['estacoes'];
            Future.delayed(Duration(seconds: 2));
            _isLoadingEstacoes = false;
          });
        }
      }
    } on SocketException catch (_) {
    } on HttpException catch (_) {
    } on FormatException catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
   
    final bikeViewModel = BikeViewModel();
    final screenSize = MediaQuery.of(context).size;
    Future<Weather> w = wf.currentWeatherByCityName("Luanda");
    Future<double?> celsius = w.then((w) => w.temperature?.celsius);
    return Scaffold(
      drawer: SideDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 232, 26),
        title: Text('BikeShared',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: badges.Badge(
                  badgeContent: Text('3'),
                  child: Icon(
                    Icons.notifications,
                    size: 30,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 30, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "🖐️, ${c.username}!",
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: const Color.fromARGB(255, 15, 232, 26),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 2),
            ),
            const Text(
              "Quer dar uma volta hoje ?",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.2),
            ),
            const SizedBox(
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
            const Text(
              "Acompanhe o tempo de hoje",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.2),
            ),
            const SizedBox(
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
                  Text(dateToday.toString(),
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
                          FutureBuilder<double?>(
                            future: celsius,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // While the future is loading
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                // If an error occurred
                                return Text('Error: ${snapshot.error}');
                              } else {
                                // When the future completes successfully
                                double value = snapshot.data ??
                                    0.0; // Access the double value
                                return Text('${value.toInt()} °C',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: AppColors.darkGrey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        height: 1.2));
                              }
                            },
                          ),
                          Text("Adequado",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: AppColors.darkGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2))
                        ],
                      ),
                      Image.asset(
                        'assets/images/suncloud.png', // Replace with your image path
                        width: screenSize.width * 0.4,
                        height: 90,
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Text("Bicicletas Próximas",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.darkGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 2)),
            SizedBox(
              height: 260,
              child:_isLoading
        ? CircularProgressIndicator()
        : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: bicicletas.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 10, top: 10),
                            width: screenSize.width * 0.65,
                            height: 440,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColors.blue,
                                  width: 0.5,
                                  style: BorderStyle.solid),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.network(
                                    'http://127.0.0.1:8000/storage/${bicicletas[index]['url']}', // Replace with your image path
                                    height: screenSize.height * 0.11,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 10, top: 20),
                                  child: Text('${bicicletas[index]['tipologia']['designacao']}',
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          color: AppColors.darkGrey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          height: 1.2)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10, left: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(bicicletas[index]['designacao'],
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: AppColors.darkGrey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              height: 1.2)),
                                      Text(' - ${bicicletas[index]['quilometragem']}m de distância',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: AppColors.darkGrey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              height: 1.2)),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                      "${formatter.format(bicicletas[index]['preco'])} \AOA/Dia",
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          color: AppColors.darkGrey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          height: 2)),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: RoundedColoredButton(
                                      width: 120,
                                      height: 40,
                                      text: "Alugar agora",
                                      textColor: AppColors.white,
                                      fillColor: const Color.fromARGB(255, 15, 232, 26),
                                      shadowBlurRadius: 0,
                                      onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BikeDetails(
                                           bicicleta: bicicletas[index]),
                                        ));
                                     
                                            
                                      }),
                                ),
                                SizedBox(height: 20,),
                                Center(child: Text('${index+1}/${bicicletas.length}'),)
                              ],
                            ),
                          );
                        },
                      )
                    
                 
            ),
            SizedBox(
              height: 20,
            ),
          const Text("Estações Próximas",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.darkGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 2)),
            SizedBox(
              height: 280,
              child:  _isLoadingEstacoes
        ? CircularProgressIndicator()
        :ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: estacoes.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 10, top: 10),
                            width: screenSize.width * 0.65,
                            height: 440,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColors.blue,
                                  width: 0.5,
                                  style: BorderStyle.solid),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.asset(
                                    'assets/images/estacao.png', // Replace with your image path
                                    height: screenSize.height * 0.11,
                                    width: 1200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text("${estacoes[index]['city']??''}",
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          color: AppColors.darkGrey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          height: 2)),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 10, top: 10),
                                  child: Text(
                                      '${estacoes[index]['estado']??''}',
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          color: AppColors.darkGrey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          height: 1.2)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text("${estacoes[index]['docas_sum_quant_bicicletas']??'0'} Bicicletas",
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          color: AppColors.darkGrey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          height: 2)),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: RoundedColoredButton(
                                      width: 120,
                                      height: 40,
                                      text: '${estacoes[index]['docas_sum_lugares']??'0'} Vagas',
                                      textColor: AppColors.white,
                                      fillColor: const Color.fromARGB(255, 15, 232, 26),
                                      shadowBlurRadius: 0,
                                      onPressed: () {
                                        /*Navigator.of(context).pushNamed(
                                            "/details",
                                            arguments: snapshot.data![index]);*/
                                      }),
                                ),
                                Center(child: Text('${index+1}/${estacoes.length}'),)
                              ],
                            ),
                          );
                        },
                      )
                    
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
