import 'package:get/get.dart';
import 'package:super_app/home_screen.dart';
import 'package:super_app/views/cashout/ListsProviderBankScreen.dart';
import 'package:super_app/views/templateA/lists_province_tempA.dart';
import 'package:super_app/views/templateA/verify_account_tempA.dart';
import 'package:super_app/views/transferwallet/ConfirmTranferScreen.dart';
import 'package:super_app/views/transferwallet/ResultTransferScreen.dart';
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
    GetPage(
      name: '/restultTransfer',
      page: () => Resulttransferscreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: '/cashOut',
      page: () => ListsProviderBankScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: '/templateA',
      page: () => ListsProvinceTempA(),
      // transition: Transition.downToUp,
    ),
    GetPage(
      name: '/verifyAccTempA',
      page: () => VerifyAccountTempA(),
      // transition: Transition.downToUp,
    ),
  ];
}
