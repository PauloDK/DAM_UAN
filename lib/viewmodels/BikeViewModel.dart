import 'package:bikesharemobile/data/provider/api.dart';
import 'package:bikesharemobile/models/Bike.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BikeViewModel extends ChangeNotifier {
  late Future<List<Bike>> bikes;
  Future<List<Bike>> fetchBikes() async {
    final url = API().getUrl();;
    final res = await API().getData('listar-bikes');
    
    if (res.statusCode == 200) {
       Map<String, dynamic> response = json.decode(res.body);
         var   bicicletas = response['trancadas'];
        
      return bicicletas.map((e) => Bike.fromJson(e)).toList();
    } else {
      throw Exception(
          'failed to load tasks,error code: ${res.statusCode}');
    }
  }
}
