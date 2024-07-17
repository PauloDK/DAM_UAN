import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PerfilController extends GetxController {
  var estadoApp = 1.obs;
  GetStorage box = GetStorage();
  String? username;
  String? nomeCompleto;
  String? email;
  String? endereco;
  String? telefone;

  final isLoading = false.obs;

  @override
  void onInit() {
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
    nomeCompleto = box.read("nome_completo");
    email = box.read("email");
    endereco = box.read("bairro");
    telefone = box.read("telefone");
  }
}
