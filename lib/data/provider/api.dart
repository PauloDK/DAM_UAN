import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class API {
  //static const _url = 'https://bikeshared.ao';
  //static const _url = 'http://127.0.0.1:8001';
  static const _url = 'http://10.10.6.92:8000';

  GetStorage box = GetStorage();
  String? _token;
  var _userId;
  String? _buildNumber;

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_token ?? ''}',
      };
  _getToken() async {
    _token = box.read('token');
  }

_getId() async {
    _userId = box.read("user_id");
  }

  String getUrl() {
    return _url;
  }

  postData(data, endPoint) async {
    await _getToken();
    var fullUrl = '$_url/api/$endPoint';
    return await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  getData(endPoint) async {
    var fullUrl = '$_url/api/$endPoint';
    //print(fullUrl);
    await _getToken();
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  Future<int> getEstado(String endpoint) async {
    await _getId();
    //await _getVersion();
    var response = await getData('$endpoint/$_userId/$_buildNumber');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    }
    return 1;
  }

  logout() async {
   // String value = box.read('checkBiometric') ?? '0';
    // // print'Valor antes do if: $value');
    await box.erase();
   // await box.write('checkBiometric', (value == '1') ? '1' : '0');
   // value = box.read('checkBiometric') ?? '0';

    final storage = new FlutterSecureStorage();
    storage.deleteAll();
    // // print'Valor depois do if: $value');
  }
}
