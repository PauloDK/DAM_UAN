import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  var estadoApp = 1.obs;
  GetStorage box = GetStorage();
  String? username;
  int? saldo;
  String? email;

  final isLoading = false.obs;

  @override
  void onInit() {
    //getCantegorias();
    _loadData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  _loadData() async {
    username = box.read("nome");
    saldo = box.read("saldo");
    email = box.read("email");
  }
}
