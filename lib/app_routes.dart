import 'package:get/get.dart';
import 'package:super_app/home_screen.dart';
import 'package:super_app/views/transferwallet/ConfirmTranferScreen.dart';
import 'package:super_app/views/transferwallet/TransferScreen.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => HomeScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: '/transfer',
      page: () => TransferScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: '/confirmTransfer',
      page: () => ConfirmTranferScreen(),
      transition: Transition.downToUp,
    ),
  ];
}
