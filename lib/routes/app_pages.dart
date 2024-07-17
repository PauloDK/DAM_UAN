import 'package:get/get.dart';
import 'package:bikesharemobile/views/home.dart';
import 'package:bikesharemobile/views/SignIn.dart';
import 'package:bikesharemobile/views/SignUp.dart';
part './app_routes.dart';

class AppPages {
  static final pages = [
    //Login
    GetPage(name: Routes.INITIAL, page: () => SignInPage()),
   
    //register
    GetPage(
      name: Routes.REGISTER,
      page: () => SignUpPage(),
      transition: Transition.leftToRight,
    ),
    //Home
    GetPage(
      name: Routes.HOME,
      page: () => Home(),
      transition: Transition.leftToRight,
    ),
  ];
}
