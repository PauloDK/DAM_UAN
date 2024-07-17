import 'package:get_storage/get_storage.dart';

class AuthService {
  GetStorage box = GetStorage();

  Future<dynamic> userId() async {
    return await box.read('user_id');
  }

  Future<dynamic> getToken() async {
    return await box.read('token');
  }
}
