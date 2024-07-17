import 'package:get/get.dart';
import 'package:bikesharemobile/controller/auth/login_controller.dart';
import 'package:bikesharemobile/data/provider/api.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<API>(() => API());
  }
}
