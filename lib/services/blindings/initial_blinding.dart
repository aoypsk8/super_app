import 'package:get/get.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/user_controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<HomeController>(() => HomeController());

    Get.put(HomeController());
    Get.put(UserController());
    // Get.lazyPut<UserController>(() => UserController(), fenix: true);
  }
}
