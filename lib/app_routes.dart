import 'package:get/get.dart';
import 'package:super_app/home_screen.dart';

class AppRoutes {
  static final routes = [GetPage(name: '/', page: () => HomeScreen(), transition: Transition.downToUp)];
}
