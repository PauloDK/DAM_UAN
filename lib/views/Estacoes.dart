
import 'package:bikesharemobile/widgets/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bikesharemobile/config/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bikesharemobile/data/provider/api.dart';
import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';


class Estacoes extends StatefulWidget {
  Estacoes({Key? key}) : super(key: key);
  @override
  State<Estacoes> createState() => _EstacoesState();
}

class _EstacoesState extends State<Estacoes> {
 
 late GoogleMapController mapController;

  final LatLng _center = const LatLng(-8.8368200, 13.2343200);
  final Map<String, Marker> _markers = {};
  
  final isLoading = false.obs;


   Future<void> _onMapCreated(GoogleMapController controller) async{
    mapController = controller;
      var response = await API().getData('obter-info-estacao');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body); 
        final googleOffices = data["estacoes"];
        print(googleOffices);
      /*setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });*/
      }
  }
 
  /*pegarEstacoes() async {
    isLoading.toggle();
    try {
      var response = await API().getData('obter-info-estacao');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body); 
        final googleOffices = data["estacoes"];
        print(googleOffices);
      setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
      }
    } on SocketException catch (_) {
    } on HttpException catch (_) {
    } on FormatException catch (_) {
    } on NoSuchMethodError catch (_) {}
    isLoading.toggle();
  } */

 


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: SideDrawer(),
      resizeToAvoidBottomInset: false,
       appBar: AppBar(
        title: Text(
          'Estações pela Cidade',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
             height: 2,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromARGB(255, 15, 232, 26),
      ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      
    );
  }
}
